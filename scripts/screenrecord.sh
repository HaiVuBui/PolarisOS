#!/usr/bin/env bash
# Toggle screen recording with wf-recorder. Saves to ~/Pictures/screenrecords/
# Usage: screenrecord.sh [region]
#   region  - use slurp to select a region; otherwise record full screen

SAVE_DIR="$HOME/Pictures/screenrecords"
mkdir -p "$SAVE_DIR"

if pgrep -x wf-recorder > /dev/null; then
    pkill -INT wf-recorder
    notify-send -i media-record "Screen Recording" "Recording stopped"
else
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    OUTPUT="$SAVE_DIR/screenrecord_$TIMESTAMP.mp4"

    if [[ "$1" == "region" ]]; then
        GEOMETRY=$(slurp) || exit 0
        wf-recorder -g "$GEOMETRY" -f "$OUTPUT" &
    else
        wf-recorder -f "$OUTPUT" &
    fi

    notify-send -i media-record "Screen Recording" "Recording started → $OUTPUT"
fi
