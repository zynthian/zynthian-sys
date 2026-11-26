#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ******************************************************************************
# ZYNTHIAN PROJECT: Software update progress display
#
# Draws the software update progress directly on the framebuffer while the UI
# is stopped (low-memory updates). It follows the update log:
#   ">>> <text>" lines are progress messages; "[n/N] xx%" in them sets the bar.
#   Any other line is shown as the current detail line.
#
# Usage: zynthian_update_progress.py [--log FILE] [--fb DEVICE] [--rotate DEG]
#
# Copyright (C) 2015-2026 Fernando Moyano <jofemodo@zynthian.org>
#
# ******************************************************************************
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
#
# ******************************************************************************

import os
import re
import sys
import time
import signal
import argparse

from PIL import Image, ImageDraw, ImageFont

try:
    import numpy
except ImportError:
    numpy = None

ZYNTHIAN_UI_DIR = os.environ.get("ZYNTHIAN_UI_DIR", "/zynthian/zynthian-ui")
LOGO_FILE = f"{ZYNTHIAN_UI_DIR}/img/zynthian_logo_boot.jpg"
FONT_FILES = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    "/usr/share/fonts/truetype/freefont/FreeSans.ttf",
]
COLOR_BG = (0, 0, 0)
COLOR_TX = (255, 255, 255)
COLOR_DIM = (160, 160, 160)
COLOR_BAR = (0, 160, 230)
COLOR_BAR_BG = (50, 50, 50)
REFRESH_PERIOD = 5  # Redraw at least every few seconds (console may scribble on the fb)

re_step = re.compile(r"\[(\d+)/(\d+)\]\s*(\d+)%")

running = True


def on_signal(signo, frame):
    global running
    running = False


# ------------------------------------------------------------------------------
# Framebuffer
# ------------------------------------------------------------------------------

class Framebuffer:

    def __init__(self, device):
        self.device = device
        name = os.path.basename(device)
        sysfs = f"/sys/class/graphics/{name}"
        self.width, self.height = [int(v) for v in self.read_sysfs(sysfs, "virtual_size").split(",")]
        self.bpp = int(self.read_sysfs(sysfs, "bits_per_pixel"))
        try:
            self.stride = int(self.read_sysfs(sysfs, "stride"))
        except (OSError, ValueError):
            self.stride = self.width * self.bpp // 8
        # Visible size may be smaller than virtual size (double buffering)
        try:
            with open(f"{sysfs}/modes") as f:
                mode = f.readline().strip()  # e.g. "U:480x320p-0"
            w, h = re.search(r"(\d+)x(\d+)", mode).groups()
            self.width, self.height = int(w), int(h)
        except (OSError, AttributeError):
            pass
        if self.bpp not in (16, 24, 32):
            raise ValueError(f"Unsupported framebuffer depth: {self.bpp} bpp")
        self.fd = open(device, "r+b", buffering=0)

    @staticmethod
    def read_sysfs(path, attr):
        with open(f"{path}/{attr}") as f:
            return f.read().strip()

    def to_bytes(self, img):
        if self.bpp == 32:
            data = img.tobytes("raw", "BGRX")
        elif self.bpp == 24:
            data = img.tobytes("raw", "BGR")
        elif numpy is not None:
            a = numpy.asarray(img, dtype=numpy.uint16)
            rgb565 = ((a[:, :, 0] >> 3) << 11) | ((a[:, :, 1] >> 2) << 5) | (a[:, :, 2] >> 3)
            data = rgb565.astype("<u2").tobytes()
        else:
            data = bytearray()
            for r, g, b in img.getdata():
                v = ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)
                data += bytes((v & 0xFF, v >> 8))
        row = self.width * self.bpp // 8
        if self.stride != row:
            pad = bytes(self.stride - row)
            data = b"".join(data[i:i + row] + pad for i in range(0, len(data), row))
        return data

    def show(self, img):
        self.fd.seek(0)
        self.fd.write(self.to_bytes(img))


# ------------------------------------------------------------------------------
# Screen rendering
# ------------------------------------------------------------------------------

class ProgressScreen:

    def __init__(self, width, height, rotate=0):
        self.width = width
        self.height = height
        self.rotate = rotate
        if rotate in (90, 270):
            self.w, self.h = height, width
        else:
            self.w, self.h = width, height
        self.font_size = max(12, self.h // 16)
        self.font_small_size = max(10, self.h // 24)
        self.font = self.load_font(self.font_size)
        self.font_small = self.load_font(self.font_small_size)
        self.logo = None
        try:
            logo = Image.open(LOGO_FILE).convert("RGB")
            logo.thumbnail((int(self.w * 0.8), int(self.h * 0.45)))
            self.logo = logo
        except Exception:
            pass

    @staticmethod
    def load_font(size):
        for fpath in FONT_FILES:
            try:
                return ImageFont.truetype(fpath, size)
            except OSError:
                continue
        try:
            return ImageFont.load_default(size)
        except TypeError:
            return ImageFont.load_default()

    def fit_text(self, draw, text, font, max_width):
        if draw.textlength(text, font=font) <= max_width:
            return text
        while text and draw.textlength(text + "...", font=font) > max_width:
            text = text[:-1]
        return text + "..."

    def render(self, title, message, percent, detail):
        img = Image.new("RGB", (self.w, self.h), COLOR_BG)
        draw = ImageDraw.Draw(img)
        margin = self.w // 20
        y = self.h // 20
        if self.logo:
            img.paste(self.logo, ((self.w - self.logo.width) // 2, y))
            y += self.logo.height + self.h // 30

        line_h = self.font_size + self.font_size // 3
        text = self.fit_text(draw, title, self.font, self.w - 2 * margin)
        draw.text(((self.w - draw.textlength(text, font=self.font)) // 2, y), text, font=self.font, fill=COLOR_TX)
        y += line_h

        text = self.fit_text(draw, message, self.font, self.w - 2 * margin)
        draw.text(((self.w - draw.textlength(text, font=self.font)) // 2, y), text, font=self.font, fill=COLOR_TX)
        y += line_h + self.h // 40

        # Progress bar
        bar_h = max(6, self.h // 24)
        draw.rectangle((margin, y, self.w - margin, y + bar_h), fill=COLOR_BAR_BG)
        if percent is not None:
            x = margin + (self.w - 2 * margin) * max(0, min(100, percent)) // 100
            if x > margin:
                draw.rectangle((margin, y, x, y + bar_h), fill=COLOR_BAR)
        y += bar_h + self.h // 30

        text = self.fit_text(draw, detail, self.font_small, self.w - 2 * margin)
        draw.text((margin, y), text, font=self.font_small, fill=COLOR_DIM)

        text = "Don't power off!"
        draw.text(((self.w - draw.textlength(text, font=self.font_small)) // 2,
                   self.h - self.font_small_size - self.h // 30), text, font=self.font_small, fill=COLOR_DIM)

        if self.rotate:
            img = img.rotate(self.rotate, expand=True)
        return img


# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Show software update progress on the framebuffer")
    parser.add_argument("--log", default="/tmp/zynthian_update.log")
    parser.add_argument("--fb", default=os.environ.get("FRAMEBUFFER", "/dev/fb0") or "/dev/fb0")
    parser.add_argument("--rotate", type=int, default=None, help="Rotation in degrees (0, 90, 180, 270)")
    args = parser.parse_args()

    rotate = args.rotate
    if rotate is None:
        rotate = 180 if os.environ.get("DISPLAY_ROTATION", "None") == "Inverted" else 0

    signal.signal(signal.SIGTERM, on_signal)
    signal.signal(signal.SIGINT, on_signal)

    try:
        fb = Framebuffer(args.fb)
    except Exception as e:
        print(f"Update progress display not available on {args.fb}: {e}", file=sys.stderr)
        return 1

    screen = ProgressScreen(fb.width, fb.height, rotate)
    title = "Updating software"
    message = "Please wait..."
    percent = None
    detail = ""
    changed = True
    last_draw = 0

    try:
        log = open(args.log, "r", errors="replace")
    except OSError:
        log = None

    while running:
        if log:
            for line in log.readlines():
                line = line.strip()
                if not line or line == "EOUPDATE":
                    continue
                if line.startswith(">>>"):
                    message = line[3:].strip()
                    m = re_step.search(message)
                    if m:
                        percent = int(m.group(3))
                        message = f"Step {m.group(1)} of {m.group(2)}: " + message[m.end():].lstrip(" :")
                    detail = ""
                else:
                    detail = line
                changed = True
        now = time.monotonic()
        if changed or now - last_draw > REFRESH_PERIOD:
            try:
                fb.show(screen.render(title, message, percent, detail))
            except OSError as e:
                print(f"Can't write to {args.fb}: {e}", file=sys.stderr)
                return 1
            changed = False
            last_draw = now
        time.sleep(0.5)
    return 0


if __name__ == "__main__":
    sys.exit(main())
