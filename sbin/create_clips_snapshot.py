#!/zynthian/venv/bin/python
# -*- coding: utf-8 -*-
# ********************************************************************
# ZYNTHIAN PROJECT: Clips snapshot generator
#
# Create a snapshot with N "audio clip" (clip launcher) chains, each one
# with M clips preloaded with samples from an installed collection
# ($ZYNTHIAN_DATA_DIR/collections/<collection>).
#
#   create_clips_snapshot.py [options] <collection> <chains> <clips> [<name>]
#   create_clips_snapshot.py --inspect [options] <collection>
#
# The collection is inspected first, getting for each sample: type
# (drums/melodic), subcollection (the folder it's in, "Stems" folders
# belong to their parent), BPM (from its path, as the clip engine does)
# and duration in bars/beats. --inspect prints this table and exits.
#
# Then the clips are arranged:
#  + Drum chains (columns) on the left, melodic chains on the right.
#  + The global tempo is --tempo, the BPM in the collection name (e.g.
#    "EDM-TECH-140BPM") or the most frequent BPM in the collection.
#  + Samples with the closest BPM to the global tempo are chosen. Samples
#    shorter than a bar or longer than --max-bars (default 32) are not used.
#  + Each row (launcher phrase) takes the clips of each type from the same
#    subcollection when possible (e.g. a song folder with its stems),
#    trying different subcollections on each row.
#  + The clip lengths in a phrase must divide one another (e.g. 1, 4, 8, 32
#    bars), so all the clips loop together.
#  + Initial mix: the mixer strip levels are reduced by 10*log10(chains) dB
#    to avoid clipping when playing all the chains together.
#
# The snapshot is saved in the "AutoClippy" snapshot bank:
# $ZYNTHIAN_MY_DATA_DIR/snapshots/<BBB>-AutoClippy/<NNN>-<name>.zss (the bank
# is created with the next free bank number BBB if it doesn't exist), where NNN is
# the next free program number and <name> defaults to <collection>-<chains>x<clips>,
# or <collection>-<BPM>BPM-<chains>x<clips> if the collection name has no BPM.
# The snapshot restores the tempo before loading the clips, so clips with the
# same BPM as the global tempo don't need rewarping.
#
# ********************************************************************
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
#
# ********************************************************************

import os
import re
import sys
import json
import math
import ctypes
import random
import argparse

# Same values & logic as zyngine/zynthian_engine_clippy.py
AUDIO_EXTENSIONS = ("wav", "ogg", "mp3", "flac", "aac")
BPM_REGEX = r"(\d+(?:\.\d+)?)\s*(?=bpm|BPM)"
MAX_BEATS = 256
DEFAULT_MAX_BARS = 32     # Longer samples are not used as clips
MAX_DURATION = 120
MAX_CLIP_CHAINS = 16
DEFAULT_PHRASES = 8
SNAPSHOT_SCHEMA_VERSION = 6
SNAPSHOT_BANK = "AutoClippy"
MAX_PROGRAMS = 128
TEMPO_PROC_ID = -4

DRUMS = "drums"
MELODIC = "melodic"
UNKNOWN = "unknown"
# Keywords (start of words) in the sample path that tell the sample type
DRUM_KEYWORDS = ("drum", "drm", "break", "beat", "perc", "fill", "hat", "kick", "snare", "rhythm", "ride", "crash",
                 "tom", "clap", "shaker", "cymbal", "groove")
MELODIC_KEYWORDS = ("melod", "chord", "key", "synth", "lead", "pad", "bass", "piano", "guitar", "pluck", "vocal",
                    "vox", "string", "arp", "organ", "brass", "flute", "bell", "harmon")

NO_BPM_COST = 0.5           # Cost of a sample without BPM (unknown tempo)
UNKNOWN_TYPE_COST = 0.3     # Extra cost of a sample of unknown type
REUSED_SUBCOL_COST = 0.02   # Extra cost of a subcollection for each previous row using it
SONG_SUBCOL_BONUS = 0.01    # Bonus for "song" subcollections (folder with BPM: a loop and its stems)
MISSING_CLIP_COST = 0.1     # Cost of each clip a subcollection can't provide in a row

# Mixer fader law (as zynlibs/zynmixer/mixer.c)
FADER_UNITY = 0.75          # Fader position for unity gain (0dB)


# --------------------------------------------------------------------
# Audio file info (libsndfile, as libzynclippy does)
# --------------------------------------------------------------------

class SF_INFO(ctypes.Structure):
    _fields_ = [("frames", ctypes.c_int64), ("samplerate", ctypes.c_int), ("channels", ctypes.c_int),
                ("format", ctypes.c_int), ("sections", ctypes.c_int), ("seekable", ctypes.c_int)]


libsndfile = ctypes.cdll.LoadLibrary("libsndfile.so.1")
libsndfile.sf_open.restype = ctypes.c_void_p
libsndfile.sf_open.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.POINTER(SF_INFO)]
libsndfile.sf_close.argtypes = [ctypes.c_void_p]


def get_audio_info(fpath):
    """Returns (frames, samplerate) or None if the file can't be read"""
    info = SF_INFO()
    sndfile = libsndfile.sf_open(fpath.encode("utf-8"), 0x10, ctypes.byref(info))  # SFM_READ
    if not sndfile:
        return None
    libsndfile.sf_close(sndfile)
    if info.frames <= 0 or info.samplerate <= 0:
        return None
    return info.frames, info.samplerate


def parse_bpm(text):
    """BPM in a text, as the clip engine gets it from the sample path"""
    matches = re.findall(BPM_REGEX, text)
    if matches:
        return float(matches[0])
    return None


def get_bars(frames, sr, bpm, bpb):
    """Bars in a sample at a BPM, rounded as the clip engine does (3.97 bars => 4 bars)"""
    fbars = frames * bpm / (60 * sr) / bpb
    bars = int(fbars)
    if fbars - bars > 0.95:
        bars += 1
    return bars


# --------------------------------------------------------------------
# Collection inspection
# --------------------------------------------------------------------

def get_sample_type(parts):
    """Sample type from the path parts (the first part with type keywords decides)"""
    for part in parts:
        words = [w for w in re.split(r"[^a-z0-9]+", part.lower()) if w]
        ndrum = sum(1 for w in words if w.startswith(DRUM_KEYWORDS))
        nmelodic = sum(1 for w in words if w.startswith(MELODIC_KEYWORDS))
        if ndrum > nmelodic:
            return DRUMS
        if nmelodic > ndrum:
            return MELODIC
    return UNKNOWN


def inspect_collection(collection_dir, bpb, tempo, max_bars=DEFAULT_MAX_BARS):
    """List of samples in the collection, with their type, subcollection, BPM & duration.

    tempo: tempo used for samples without BPM
    """
    samples = []
    for root, dirs, fnames in os.walk(collection_dir):
        dirs.sort()
        for fname in sorted(fnames):
            if fname.rsplit(".", 1)[-1].lower() not in AUDIO_EXTENSIONS:
                continue
            fpath = os.path.join(root, fname)
            rel_dir = os.path.relpath(root, collection_dir)
            dir_parts = [] if rel_dir == "." else rel_dir.split(os.sep)
            stem = bool(dir_parts) and dir_parts[-1].lower() == "stems"
            if stem:
                dir_parts = dir_parts[:-1]
            # Subcollection: the folder of the sample ("Stems" belong to their parent), without "Samples/"
            subcol_parts = dir_parts[1:] if dir_parts and dir_parts[0].lower() == "samples" else dir_parts
            subcol = "/".join(subcol_parts)
            sample = {
                "path": fpath,
                "sample": os.path.relpath(fpath, collection_dir),
                "type": get_sample_type(dir_parts + [os.path.splitext(fname)[0]]),
                "subcol": subcol,
                "song": bool(subcol_parts) and parse_bpm(subcol_parts[-1]) is not None,
                "stem": stem,
                "bpm": parse_bpm(fpath),
                "bars": None,
                "beats": None,
                "status": "ok"
            }
            samples.append(sample)

            info = get_audio_info(fpath)
            if not info:
                sample["status"] = "can't read file"
                continue
            frames, sr = info
            bpm = sample["bpm"] or tempo
            bars = get_bars(frames, sr, bpm, bpb)
            sample["frames"] = frames
            sample["sr"] = sr
            sample["bars"] = bars
            sample["beats"] = bars * bpb
            duration = bars * bpb * 60 / bpm
            if bars < 1:
                sample["status"] = "shorter than a bar"
            elif bars > max_bars:
                sample["status"] = f"longer than {max_bars} bars"
            elif bars * bpb > MAX_BEATS or duration > MAX_DURATION:
                sample["status"] = "too long to warp"
    return samples


def print_table(samples):
    print("sample\ttype\tsubcollection\tBPM\tbars\tbeats\tstatus")
    for s in samples:
        bpm = f"{s['bpm']:g}" if s["bpm"] else "-"
        bars = s["bars"] if s["bars"] is not None else "-"
        beats = s["beats"] if s["beats"] is not None else "-"
        print(f"{s['sample']}\t{s['type']}\t{s['subcol'] or '-'}\t{bpm}\t{bars}\t{beats}\t{s['status']}")


# --------------------------------------------------------------------
# Clip arrangement
# --------------------------------------------------------------------

def most_frequent_bpm(samples):
    """Most frequent BPM among the usable samples (ties => the one with more melodic samples)"""
    counts = {}
    for s in samples:
        if s["status"] == "ok" and s["bpm"]:
            n = counts.setdefault(s["bpm"], [0, 0])
            n[0] += 1
            n[1] += s["type"] == MELODIC
    if not counts:
        return None
    return max(counts, key=lambda bpm: counts[bpm])


def sample_cost(sample, tempo, stype):
    """How bad is a sample for a column of type stype at a tempo"""
    if sample["bpm"]:
        cost = abs(sample["bpm"] - tempo) / tempo
    else:
        cost = NO_BPM_COST
    if sample["type"] != stype:
        cost += UNKNOWN_TYPE_COST
    return cost


def compatible_bars(bars, row_bars):
    """True if a clip length (bars) can be combined with the other clips of a phrase: each pair of lengths
    must divide one another (e.g. 1, 4, 8, 32 is fine, 4, 12, 32 or 16, 24 is not), so all the clips loop together"""
    return all(bars % b == 0 or b % bars == 0 for b in row_bars)


def pick_compatible(ranked, n, row_bars):
    """Pick up to n samples, in rank order, whose lengths are compatible with row_bars & between them"""
    picks = []
    for s in ranked:
        if compatible_bars(s["bars"], row_bars + [p["bars"] for p in picks]):
            picks.append(s)
            if len(picks) == n:
                break
    return picks


def arrange(samples, blocks, nrows, tempo, rnd):
    """Choose the clips for each block of columns of a type.

    blocks: List of (type, number of columns)
    Returns: (dictionary of grids [row][col] of samples by type, number of phrases with incompatible lengths)
             or None if there are not enough samples

    Each row (phrase) takes the clips of each type from the subcollection that provides the closest BPMs,
    preferring subcollections not used yet in previous rows. All the clip lengths in a phrase must be
    compatible (see compatible_bars). The type with fewer samples chooses first.
    """
    usable = [s for s in samples if s["status"] == "ok"]
    blocks = sorted(blocks, key=lambda b: sum(1 for s in usable if s["type"] == b[0]))
    grids = {stype: [] for stype, ncols in blocks}
    used_subcols = {stype: {} for stype, ncols in blocks}
    used = set()
    relaxed = 0
    for row in range(nrows):
        row_bars = []
        row_relaxed = False
        for stype, ncols in blocks:
            pool = [s for s in usable if s["path"] not in used and s["type"] in (stype, UNKNOWN)]
            by_subcol = {}
            for s in pool:
                by_subcol.setdefault(s["subcol"], []).append(s)

            # In a song folder with stems, several columns take the stems, a single column takes the full loop
            def rank(s):
                stem_rank = 0 if s["stem"] == (ncols > 1) else 1
                return (round(sample_cost(s, tempo, stype), 3), stem_rank, rnd.random())

            best = None
            for subcol, items in by_subcol.items():
                picks = pick_compatible(sorted(items, key=rank), ncols, row_bars)
                if not picks:
                    continue
                cost = sum(sample_cost(s, tempo, stype) for s in picks) / len(picks)
                cost += MISSING_CLIP_COST * (ncols - len(picks))
                cost += REUSED_SUBCOL_COST * used_subcols[stype].get(subcol, 0)
                if picks[0]["song"]:
                    cost -= SONG_SUBCOL_BONUS
                cost += rnd.random() * 0.001
                if best is None or cost < best[0]:
                    best = (cost, subcol, picks)
            picks = []
            if best:
                picks = best[2]
                used_subcols[stype][best[1]] = used_subcols[stype].get(best[1], 0) + 1
            # Fill missing clips with the closest compatible samples from other subcollections
            if len(picks) < ncols:
                others = sorted((s for s in pool if s not in picks), key=rank)
                picks += pick_compatible(others, ncols - len(picks), row_bars + [p["bars"] for p in picks])
            # Not enough compatible samples => use the closest ones anyway
            if len(picks) < ncols:
                others = sorted((s for s in pool if s not in picks), key=rank)
                picks += others[:ncols - len(picks)]
                row_relaxed = True
            if len(picks) < ncols:
                return None
            for s in picks:
                used.add(s["path"])
            row_bars += [s["bars"] for s in picks]
            grids[stype].append(picks)
        relaxed += row_relaxed
    return grids, relaxed


def get_clip_config(sample, tempo, bpb):
    """Clip controller values for a sample (as zynthian_engine_clippy.set_file does when loading a new file)"""
    bpm = sample["bpm"] or tempo
    beats = sample["bars"] * bpb
    duration = beats * 60 / bpm
    return {
        "file": sample["path"],
        "warp": 1,
        "beats": beats,
        "mode": 1,
        "gain": 0.0,
        "crop_start": 0,
        "crop_end": int(duration * sample["sr"]),
        "zoom": 1,
        "beat_slice": sample["bpm"] is not None
    }


# --------------------------------------------------------------------
# Snapshot generation
# --------------------------------------------------------------------

def db_to_level(db):
    """Mixer fader level (position) for a gain in dB (as zynmixer's gainToLevel)"""
    # Fader headroom: dB above unity at the top of the fader (as zynthian_gui_config.fader_zero_db)
    try:
        headroom = -min(-1.0, max(-40.0, float(os.environ.get("ZYNTHIAN_MIXER_FADER_ZERO_DB", -10.0))))
    except ValueError:
        headroom = 10.0
    gain = 10 ** (db / 20)
    if gain >= 1.0:
        return min(1.0, FADER_UNITY + (1.0 - FADER_UNITY) * db / headroom)
    fader_exp = headroom / (1.0 - FADER_UNITY) * FADER_UNITY * 0.115129255
    return FADER_UNITY * gain ** (1.0 / fader_exp)


def get_mix_db(nchains):
    """Initial mixer strip gain (dB) for mixing nchains clip chains without clipping: the sum of N
    uncorrelated signals of the same level is 10*log10(N) dB louder than each one"""
    return -10 * math.log10(nchains) if nchains > 1 else 0.0


def get_zynseq_state(tempo, bpb, phrases, clip_chans, clip_names):
    """zynseq state with the clip sequences configured (same format as libzynseq getState)"""
    scene_phrases = []
    for phrase in range(phrases):
        sequences = []
        # MIDI channel sequences (0-15), each one with its (empty) pattern
        for chan in range(16):
            sequences.append({"mode": 1, "group": chan, "name": "", "repeat": 0, "followAction": 1, "followParam": 0,
                              "state": 0, "tracks": [{"chan": chan, "output": 0, "map": 0, "patns": {"0": phrase * 16 + chan + 1}}]})
        # Clip launcher sequences (16-31)
        for chan in range(16, 32):
            name = clip_names.get((chan, phrase), "")
            repeat = 255 if chan in clip_chans else 0
            sequences.append({"mode": 1, "group": chan, "name": name, "repeat": repeat, "followAction": 1, "followParam": 0,
                              "state": 0, "tracks": [{"chan": 0, "output": 0, "map": 0}]})
        scene_phrases.append({"name": "", "mode": 1, "bpb": bpb, "tempo": 0.0, "repeat": 255, "followAction": 0,
                              "followParam": 0, "playFlags": 0, "followRepeat": 0, "state": 0, "sequences": sequences})
    return {"tempo": tempo, "bpb": bpb, "scene": 0, "scenes": [{"phrases": scene_phrases}]}


def get_snapshot(chains_clips, chain_titles, tempo, bpb):
    proc_info = {"bank_info": None, "bank_subdir_info": None, "preset_info": None, "preset_subdir_info": None}
    phrases = max(DEFAULT_PHRASES, max(len(clips) for clips in chains_clips))
    chains = {}
    zs3_chains = {}
    processors = {
        str(TEMPO_PROC_ID): {**proc_info, "controllers": {"bpm": {"value": tempo}, "bpb": {"value": bpb}}}
    }
    clip_names = {}
    clip_chans = []
    # Initial mix: reduce the strip levels according to the number of chains
    mix_level = db_to_level(get_mix_db(len(chains_clips)))
    for i, clips in enumerate(chains_clips):
        chain_id = str(i + 1)
        midi_chan = 16 + i
        clip_proc_id = 2 * i + 1
        clip_chans.append(midi_chan)
        chains[chain_id] = {"title": chain_titles[i], "midi_chan": midi_chan, "midi_thru": False, "audio_thru": False,
                            "zmop_index": None, "cc_route": [],
                            "slots": [{str(clip_proc_id): "CL"}, {str(clip_proc_id + 1): "MI"}], "zctrls": []}
        zs3_chains[chain_id] = {"audio_in": [], "audio_out": [0]}
        controllers = {"record": {"value": 0}}
        for phrase, clip in enumerate(clips):
            for symbol, value in clip.items():
                controllers[f"{symbol} {phrase + 1}"] = {"value": value}
            # As the clip engine names the sequences (truncated by zynseq)
            clip_names[(midi_chan, phrase)] = os.path.splitext(os.path.basename(clip["file"]))[0][:16]
        processors[str(clip_proc_id)] = {**proc_info, "controllers": controllers}
        processors[str(clip_proc_id + 1)] = {**proc_info, "controllers": {"level": {"value": mix_level}}}

    chains["0"] = {"title": "Main", "midi_chan": None, "midi_thru": False, "audio_thru": True, "zmop_index": None,
                   "cc_route": [], "slots": [{"-1": "MR"}], "zctrls": []}
    zs3_chains["0"] = {"audio_in": [], "audio_out": ["^system:playback_1$|^system:playback_2$"]}

    return {
        "schema_version": SNAPSHOT_SCHEMA_VERSION,
        "chains": chains,
        "zs3": {
            "zs3-0": {
                "title": "Last state",
                "active_chain": 1,
                "active_phrase": 0,
                "global": {"clock_source": None, "clock_outputs": [], "zynseq_excluded_inputs": [], "midi_transpose": 0},
                "chains": zs3_chains,
                "processors": processors
            }
        },
        "last_zs3_id": None,
        "gui": {"pinned_chains": 1},
        # zynseq state (incl. tempo) is restored before the clips (zs3-0) => no rewarping
        "zynseq": get_zynseq_state(tempo, bpb, phrases, clip_chans, clip_names)
    }


def get_bank_dir(snapshots_dir):
    """Directory of the snapshot bank (NNN-AutoClippy), created with the next free bank number if needed"""
    used = set()
    for dname in sorted(os.listdir(snapshots_dir)):
        if not os.path.isdir(os.path.join(snapshots_dir, dname)):
            continue
        m = re.match(r"(\d{3})(-(.*))?$", dname)
        if m:
            if m.group(3) == SNAPSHOT_BANK:
                return os.path.join(snapshots_dir, dname)
            used.add(int(m.group(1)))
    bank = next((i for i in range(1, MAX_PROGRAMS) if i not in used), None)
    if bank is None:
        sys.exit(f"ERROR => No free snapshot bank number in '{snapshots_dir}'")
    bank_dir = os.path.join(snapshots_dir, f"{bank:03d}-{SNAPSHOT_BANK}")
    os.makedirs(bank_dir)
    return bank_dir


def get_output_path(name):
    """Snapshot path in the bank, with the next free program number"""
    bank_dir = get_bank_dir(os.path.join(os.environ["ZYNTHIAN_MY_DATA_DIR"], "snapshots"))
    used = set()
    for fname in os.listdir(bank_dir):
        m = re.match(r"(\d{3})-.*\.zss$", fname)
        if m:
            used.add(int(m.group(1)))
    program = next((i for i in range(1, MAX_PROGRAMS) if i not in used), None)
    if program is None:
        sys.exit(f"ERROR => No free program number in snapshot bank '{bank_dir}'")
    return os.path.join(bank_dir, f"{program:03d}-{name}.zss")


# --------------------------------------------------------------------
# Main
# --------------------------------------------------------------------

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create a snapshot with audio clip chains preloaded with samples from a collection")
    parser.add_argument("collection", help="installed collection name (directory in $ZYNTHIAN_DATA_DIR/collections)")
    parser.add_argument("chains", type=int, nargs="?", help=f"number of audio clip chains (1-{MAX_CLIP_CHAINS})")
    parser.add_argument("clips", type=int, nargs="?", help="number of clips (samples) in each chain")
    parser.add_argument("name", nargs="?",
                        help="snapshot name (default <collection>[-<BPM>BPM]-<chains>x<clips>)")
    parser.add_argument("--inspect", action="store_true", help="print the collection's sample table and exit")
    parser.add_argument("--drum-chains", type=int,
                        help="number of drum chains (default: half of the chains, or all if the collection has only one type)")
    parser.add_argument("--tempo", type=float,
                        help="global tempo (default: BPM in the collection name or the most frequent BPM)")
    parser.add_argument("--bpb", type=int, default=4, help="beats per bar (default 4)")
    parser.add_argument("--max-bars", type=int, default=DEFAULT_MAX_BARS,
                        help=f"maximum clip length in bars, longer samples are not used (default {DEFAULT_MAX_BARS})")
    parser.add_argument("--seed", type=int, help="random seed, for reproducible snapshots")
    args = parser.parse_args()

    if not args.inspect:
        if args.chains is None or args.clips is None:
            parser.error("chains and clips are required")
        if not 1 <= args.chains <= MAX_CLIP_CHAINS:
            sys.exit(f"ERROR => Number of chains must be 1-{MAX_CLIP_CHAINS}")
        if args.clips < 1:
            sys.exit("ERROR => Number of clips must be at least 1")
        if args.drum_chains is not None and not 0 <= args.drum_chains <= args.chains:
            sys.exit("ERROR => Number of drum chains must be between 0 and the number of chains")
    if args.bpb < 1:
        sys.exit("ERROR => Beats per bar must be at least 1")
    if args.max_bars < 1:
        sys.exit("ERROR => Maximum bars must be at least 1")
    if args.name and "/" in args.name:
        sys.exit("ERROR => Snapshot name can't contain '/'")

    collections_dir = os.path.join(os.environ["ZYNTHIAN_DATA_DIR"], "collections")
    collection_dir = os.path.join(collections_dir, args.collection)
    if not os.path.isdir(collection_dir):
        installed = sorted(d for d in os.listdir(collections_dir) if os.path.isdir(os.path.join(collections_dir, d))) \
            if os.path.isdir(collections_dir) else []
        sys.exit(f"ERROR => Collection '{args.collection}' is not installed. Installed collections: "
                 + (", ".join(installed) if installed else "none"))

    # Inspect the collection. Samples without BPM are measured at the given tempo (or 120)
    samples = inspect_collection(collection_dir, args.bpb, args.tempo or parse_bpm(args.collection) or 120.0, args.max_bars)
    if args.inspect:
        print_table(samples)
        sys.exit(0)

    usable = [s for s in samples if s["status"] == "ok"]
    ntypes = {t: sum(1 for s in usable if s["type"] == t) for t in (DRUMS, MELODIC)}
    if args.drum_chains is not None:
        ndrum = args.drum_chains
    elif not ntypes[MELODIC]:
        ndrum = args.chains
    elif not ntypes[DRUMS]:
        ndrum = 0
    else:
        ndrum = args.chains // 2
    nmelodic = args.chains - ndrum

    tempo = args.tempo or parse_bpm(args.collection) or most_frequent_bpm(samples) or 120.0
    if args.tempo is None and parse_bpm(args.collection) is None:
        # Samples without BPM were measured at 120 => measure again at the chosen tempo
        samples = inspect_collection(collection_dir, args.bpb, tempo, args.max_bars)

    rnd = random.Random(args.seed)
    blocks = [(stype, ncols) for stype, ncols in ((DRUMS, ndrum), (MELODIC, nmelodic)) if ncols]
    res = arrange(samples, blocks, args.clips, tempo, rnd)
    if res is None:
        sys.exit(f"ERROR => Collection '{args.collection}' hasn't enough usable samples for {ndrum} drum chains +"
                 f" {nmelodic} melodic chains x {args.clips} clips ({len(usable)} usable samples of {len(samples)})")
    grids, relaxed = res
    columns = []
    chain_titles = []
    for stype, ncols, title in ((DRUMS, ndrum, "Drums"), (MELODIC, nmelodic, "Melody")):
        if not ncols:
            continue
        grid = grids[stype]
        for col in range(ncols):
            columns.append([grid[row][col] for row in range(args.clips)])
            chain_titles.append(f"{title} {col + 1}" if ncols > 1 else title)

    if args.name:
        name = args.name
    elif parse_bpm(args.collection) == tempo:
        name = f"{args.collection}-{args.chains}x{args.clips}"
    else:
        name = f"{args.collection}-{tempo:g}BPM-{args.chains}x{args.clips}"
    chains_clips = [[get_clip_config(s, tempo, args.bpb) for s in col] for col in columns]
    snapshot = get_snapshot(chains_clips, chain_titles, tempo, args.bpb)
    output = get_output_path(name)
    try:
        with open(output, "w") as f:
            json.dump(snapshot, f)
    except Exception as e:
        sys.exit(f"ERROR => Can't save '{output}' => {e}")

    print(f"Created '{output}': {args.chains} chains x {args.clips} clips from '{args.collection}', tempo {tempo:g} BPM,"
          f" mixer strips at {get_mix_db(args.chains):.1f}dB")
    for row in range(args.clips):
        cells = []
        for col, title in zip(columns, chain_titles):
            s = col[row]
            bpm = f"{s['bpm']:g}" if s["bpm"] else "?"
            cells.append(f"{title}: {os.path.basename(s['subcol']) or '-'} / {os.path.splitext(os.path.basename(s['path']))[0]}"
                         f" ({bpm}, {s['bars']} bars)")
        print(f"  {row + 1:2d}. " + " | ".join(cells))
    if relaxed:
        print(f"WARNING: {relaxed} phrases have clips with incompatible lengths (not enough compatible samples)")
