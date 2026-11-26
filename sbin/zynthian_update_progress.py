#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ******************************************************************************
# ZYNTHIAN PROJECT: Software update progress display
#
# Renders the software update progress screen, following the update log:
#   ">>> <text>" lines are progress messages; "[n/N] xx%" in them sets the bar.
#   Any other line is shown as the current detail line.
#
# Used in two ways:
#   + As a module by the zynthian UI, which shows the screen while it is running.
#   + As a program that draws directly on the framebuffer, while the UI is
#     stopped (low-memory updates) or not running:
#       zynthian_update_progress.py [--log FILE] [--fb DEVICE] [--rotate DEG] [--wait-x]
#     It puts the console in graphics mode, so the kernel doesn't draw text over it,
#     and leaves it so when stopped (SIGTERM): the console isn't shown between the
#     update steps, or while the UI starts. At the end of the update,
#       zynthian_update_progress.py --text-mode
#     restores text mode (once the UI's X server has its own VT).
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
import glob
import time
import fcntl
import struct
import signal
import argparse

from PIL import Image, ImageDraw, ImageFont

try:
    import numpy
except ImportError:
    numpy = None

ZYNTHIAN_DIR = os.environ.get("ZYNTHIAN_DIR", "/zynthian")
UPDATE_LOG = "/tmp/zynthian_update.log"
UPDATE_STATE_DIR = "/run/zynthian_update"
# Exists while an update is running
UPDATE_RUNNING_FILE = f"{UPDATE_STATE_DIR}/running"
# Start time (epoch seconds) of the update and of the current step
UPDATE_START_FILE = f"{UPDATE_STATE_DIR}/start_time"
STEP_START_FILE = f"{UPDATE_STATE_DIR}/step_time"
# VT put in graphics mode by the progress display
VT_FILE = f"{UPDATE_STATE_DIR}/vt"

LOGO_FILES = [
    f"{ZYNTHIAN_DIR}/zynthian-webconf/img/logo/zynthian_logo_black_trans_big.png",
    f"{ZYNTHIAN_DIR}/zynthian-webconf/img/logo/zynthian_logo_black_trans_640.png",
    f"{ZYNTHIAN_DIR}/zynthian-ui/icons/zynthian_logo.png",
]
FONT_FILES = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    "/usr/share/fonts/truetype/freefont/FreeSans.ttf",
]
COLOR_BG = (0, 0, 0)
COLOR_TX = (255, 255, 255)
COLOR_DIM = (160, 160, 160)
COLOR_HINT = (230, 180, 60)
COLOR_BAR = (0, 160, 230)
COLOR_BAR_BG = (50, 50, 50)
COLOR_BAR_PULSE = (110, 110, 110)

# Log quiet for longer than this (seconds) => tell the user it is still working
IDLE_HINT_TIME = 20
# Long running stages, recognised by their log lines
LONG_STAGE_HINTS = [
    (re.compile(r"Regenerating engines DB|zynthian_lv2\.py", re.IGNORECASE),
     "Scanning LV2 plugins. This can take several minutes..."),
    (re.compile(r"apt-get|Unpacking|Setting up|Get:\d+", re.IGNORECASE),
     "Installing packages. This can take a while..."),
]

re_step = re.compile(r"\[(\d+)/(\d+)\]\s*(\d+)%")


def read_epoch_file(fpath):
    try:
        with open(fpath) as f:
            return float(f.read().strip())
    except (OSError, ValueError):
        return None


def format_time(seconds):
    seconds = max(0, int(seconds))
    if seconds >= 3600:
        return f"{seconds // 3600}:{seconds // 60 % 60:02d}:{seconds % 60:02d}"
    return f"{seconds // 60:02d}:{seconds % 60:02d}"


# ------------------------------------------------------------------------------
# Update progress state, from the update log
# ------------------------------------------------------------------------------

class ProgressState:

    def __init__(self, log_fpath=UPDATE_LOG):
        self.log_fpath = log_fpath
        self.log = None
        self.log_pos = 0
        now = time.time()
        self.start_time = now
        self.step_time = now
        self.last_line_time = now
        self.message = "Starting update..."
        self.percent = 0
        self.detail = ""
        self.hint = ""
        self.finished = False

    def read_log(self):
        """Read new lines from the update log. Returns True if anything changed."""
        if self.log is None:
            try:
                self.log = open(self.log_fpath, "r", errors="replace")
                self.log_pos = 0
            except OSError:
                return False
        try:
            # Log truncated => a new update started
            if os.path.getsize(self.log_fpath) < self.log_pos:
                self.log.seek(0)
                self.__init__(self.log_fpath)
                return self.read_log()
        except OSError:
            pass
        changed = False
        for line in self.log.readlines():
            changed |= self.feed(line)
        self.log_pos = self.log.tell()
        # Times saved by the update scripts are better than ours (we may have started late)
        self.start_time = read_epoch_file(UPDATE_START_FILE) or self.start_time
        self.step_time = read_epoch_file(STEP_START_FILE) or self.step_time
        return changed

    def feed(self, line):
        line = line.strip()
        if not line:
            return False
        self.last_line_time = time.time()
        if line == "EOUPDATE":
            self.finished = True
            return True
        if line.startswith(">>>"):
            msg = line[3:].strip()
            m = re_step.search(msg)
            if m:
                self.percent = int(m.group(3))
                msg = f"Step {m.group(1)} of {m.group(2)}: " + msg[m.end():].lstrip(" :")
            elif msg.startswith("Restarting"):
                self.percent = 100
            self.message = msg
            self.detail = ""
            self.hint = ""
            self.step_time = self.last_line_time
        else:
            self.detail = line
            if line.startswith("Update Complete"):
                self.message = line
                self.percent = 100
                self.detail = ""
                self.hint = ""
            for regex, hint in LONG_STAGE_HINTS:
                if regex.search(line):
                    self.hint = hint
                    break
        return True

    def get_hint(self):
        idle = time.time() - self.last_line_time
        if self.hint:
            return self.hint
        if idle > IDLE_HINT_TIME and not self.finished:
            return f"Still working... (no output for {format_time(idle)})"
        return ""


# ------------------------------------------------------------------------------
# Screen rendering
# ------------------------------------------------------------------------------

class ProgressScreen:

    def __init__(self, width, height, rotate=0):
        self.rotate = rotate
        if rotate in (90, 270):
            self.w, self.h = height, width
        else:
            self.w, self.h = width, height
        self.font_size = max(14, self.h // 14)
        self.font_small_size = max(10, self.h // 24)
        self.font = self.load_font(self.font_size)
        self.font_small = self.load_font(self.font_small_size)
        self.margin = self.w // 20
        self.tick = 0
        self.base = self.create_base()

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

    def create_base(self):
        """Background with the logo. Returns the image; sets self.content_y."""
        img = Image.new("RGB", (self.w, self.h), COLOR_BG)
        y = self.h // 16
        for fpath in LOGO_FILES:
            try:
                logo = Image.open(fpath).convert("RGBA")
            except Exception:
                continue
            logo.thumbnail((int(self.w * 0.85), int(self.h * 0.27)), Image.LANCZOS)
            img.paste(logo, ((self.w - logo.width) // 2, y), logo)
            y += logo.height
            break
        self.content_y = y + self.h // 14
        return img

    def fit_text(self, draw, text, font, max_width):
        if draw.textlength(text, font=font) <= max_width:
            return text
        while text and draw.textlength(text + "...", font=font) > max_width:
            text = text[:-1]
        return text + "..."

    def draw_centered(self, draw, y, text, font, color):
        text = self.fit_text(draw, text, font, self.w - 2 * self.margin)
        draw.text(((self.w - draw.textlength(text, font=font)) // 2, y), text, font=font, fill=color)

    def render(self, state):
        """Render the progress screen for a ProgressState. Each call advances the activity animation."""
        self.tick += 1
        now = time.time()
        img = self.base.copy()
        draw = ImageDraw.Draw(img)
        margin = self.margin
        y = self.content_y
        small_h = self.font_small_size + self.font_small_size // 2

        self.draw_centered(draw, y, state.message, self.font, COLOR_TX)
        y += self.font_size + self.font_size // 2

        # Progress bar, with a pulse moving along it to show activity
        bar_h = max(8, self.h // 22)
        x0, x1 = margin, self.w - margin
        draw.rectangle((x0, y, x1, y + bar_h), fill=COLOR_BAR_BG)
        xp = x0 + (x1 - x0) * max(0, min(100, state.percent)) // 100
        if not state.finished:
            pulse_w = max(bar_h * 2, (x1 - x0) // 8)
            span = (x1 - x0) + pulse_w
            px = x0 - pulse_w + (self.tick * max(4, span // 24)) % span
            draw.rectangle((max(x0, px), y, min(x1, px + pulse_w), y + bar_h), fill=COLOR_BAR_PULSE)
        if xp > x0:
            draw.rectangle((x0, y, xp, y + bar_h), fill=COLOR_BAR)
        if not state.finished:
            # Pulse over the done part too, so it's visible at any percentage
            if px < xp:
                draw.rectangle((max(x0, px), y, min(xp, px + pulse_w), y + bar_h), fill=(90, 200, 250))
        y += bar_h + self.h // 40

        elapsed = f"Elapsed {format_time(now - state.start_time)}"
        if not state.finished:
            elapsed += f"   This step {format_time(now - state.step_time)}"
        self.draw_centered(draw, y, elapsed, self.font_small, COLOR_DIM)
        y += small_h + self.h // 60

        text = self.fit_text(draw, state.detail, self.font_small, self.w - 2 * margin)
        draw.text((margin, y), text, font=self.font_small, fill=COLOR_DIM)
        y += small_h

        hint = state.get_hint()
        if hint:
            self.draw_centered(draw, y, hint, self.font_small, COLOR_HINT)

        if not state.finished:
            self.draw_centered(draw, self.h - small_h - self.h // 40, "Don't power off!", self.font_small, COLOR_DIM)

        if self.rotate:
            img = img.rotate(self.rotate, expand=True)
        return img


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
# Console (VT) mode: in graphics mode, the kernel console doesn't draw on the display
# ------------------------------------------------------------------------------

KDSETMODE = 0x4B3A
KD_TEXT = 0
KD_GRAPHICS = 1
VT_GETSTATE = 0x5603


def get_active_vt():
    try:
        fd = os.open("/dev/tty0", os.O_RDWR | os.O_NOCTTY)
        try:
            return struct.unpack("HHH", fcntl.ioctl(fd, VT_GETSTATE, bytes(6)))[0]
        finally:
            os.close(fd)
    except OSError:
        return None


def set_vt_mode(vt, mode):
    try:
        fd = os.open(f"/dev/tty{vt}", os.O_RDWR | os.O_NOCTTY)
        try:
            fcntl.ioctl(fd, KDSETMODE, mode)
            return True
        finally:
            os.close(fd)
    except OSError as e:
        print(f"Can't set mode of VT {vt}: {e}", file=sys.stderr)
        return False


def x_running():
    return bool(glob.glob("/tmp/.X*-lock"))


def restore_text_mode():
    """Set back to text mode the VT left in graphics mode, unless X is using it now."""
    try:
        with open(VT_FILE) as f:
            vt = int(f.read().strip())
    except (OSError, ValueError):
        return
    if x_running() and get_active_vt() == vt:
        # X took this VT: it restores the mode it found when it exits
        pass
    else:
        set_vt_mode(vt, KD_TEXT)
    try:
        os.remove(VT_FILE)
    except OSError:
        pass


# ------------------------------------------------------------------------------
# Main: draw on the framebuffer
# ------------------------------------------------------------------------------

running = True


def on_signal(signo, frame):
    global running
    running = False


def main():
    parser = argparse.ArgumentParser(description="Show software update progress on the framebuffer")
    parser.add_argument("--log", default=UPDATE_LOG)
    parser.add_argument("--fb", default=os.environ.get("FRAMEBUFFER", "/dev/fb0") or "/dev/fb0")
    parser.add_argument("--rotate", type=int, default=None, help="Rotation in degrees (0, 90, 180, 270)")
    parser.add_argument("--wait-x", action="store_true", help="Get ready, then wait for the X server to exit")
    parser.add_argument("--text-mode", action="store_true", help="Restore text mode of the console and exit")
    args = parser.parse_args()

    if args.text_mode:
        restore_text_mode()
        return 0

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
    state = ProgressState(args.log)
    state.read_log()
    img = screen.render(state)

    # Ready: wait for the UI to release the display
    if args.wait_x:
        timeout = time.monotonic() + 60
        while running and x_running() and time.monotonic() < timeout:
            time.sleep(0.05)

    # Stop the kernel console drawing on the display
    vt = get_active_vt()
    if vt and set_vt_mode(vt, KD_GRAPHICS):
        try:
            with open(VT_FILE, "w") as f:
                f.write(str(vt))
        except OSError:
            pass

    res = 0
    while running:
        try:
            fb.show(img)
        except OSError as e:
            print(f"Can't write to {args.fb}: {e}", file=sys.stderr)
            res = 1
            break
        time.sleep(0.5)
        state.read_log()
        # Redrawn every time: animates the activity pulse and elapsed times
        img = screen.render(state)

    if res:
        # Can't show progress: let the console show
        restore_text_mode()
    return res


if __name__ == "__main__":
    sys.exit(main())
