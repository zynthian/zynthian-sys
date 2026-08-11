#!/usr/bin/env python3

import re
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox


def get_display_modes():
    """Return (output_name, resolutions, current_index)."""

    result = subprocess.run(
        ["xrandr", "-q"],
        capture_output=True,
        text=True,
        check=True
    )

    output = None
    resolutions = []
    current_index = None
    parsing = False

    for line in result.stdout.splitlines():

        # Look for the primary display
        m = re.match(r'^(\S+)\s+connected\s+primary', line)
        if m:
            output = m.group(1)
            parsing = True
            continue

        # If no primary, use the first connected display
        if output is None:
            m = re.match(r'^(\S+)\s+connected', line)
            if m:
                output = m.group(1)
                parsing = True
                continue

        # Stop when another output begins
        if parsing and re.match(r'^\S+\s+(connected|disconnected)', line):
            break

        if parsing:
            m = re.match(r'^\s+(\d+x\d+)\s', line)
            if m:
                res = m.group(1)
                if res not in resolutions:
                    resolutions.append(res)
                    if "*" in line:
                        current_index = len(resolutions) - 1

    return output, resolutions, current_index


class ResolutionDialog(tk.Tk):

    def __init__(self):
        super().__init__()

        self.title("Screen Resolution")
        self.resizable(False, False)
        self.geometry("300x120")

        self.output, self.resolutions, self.current = get_display_modes()

        ttk.Label(self, text="Resolution:").pack(pady=(10, 0))

        self.combo = ttk.Combobox(
            self,
            values=self.resolutions,
            state="readonly",
            width=18
        )
        self.combo.pack(pady=5)

        if self.current is not None:
            self.combo.current(self.current)

        buttons = ttk.Frame(self)
        buttons.pack(pady=10)

        ttk.Button(
            buttons,
            text="Cancel",
            command=self.destroy
        ).pack(side=tk.LEFT, padx=5)

        ttk.Button(
            buttons,
            text="Apply",
            command=self.apply
        ).pack(side=tk.LEFT, padx=5)

    def apply(self):
        resolution = self.combo.get()

        try:
            subprocess.run(
                [
                    "xrandr",
                    "--output", self.output,
                    "--mode", resolution
                ],
                check=True
            )
            self.destroy()

        except subprocess.CalledProcessError as e:
            messagebox.showerror(
                "Error",
                f"Failed to set resolution:\n{e}"
            )


if __name__ == "__main__":
    ResolutionDialog().mainloop()