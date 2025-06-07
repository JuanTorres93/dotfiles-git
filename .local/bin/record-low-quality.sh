#!/bin/bash

# Settings
RESOLUTION="2560x1440"
FRAMERATE=25
DISPLAY=":0.0"

# Determine output filename
if [ -n "$1" ]; then
  BASENAME="${1%.mp4}"
  OUTPUT="${BASENAME}.mp4"
else
  OUTPUT="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
fi

# Recording command (low quality, small file, readable text)
ffmpeg -video_size "$RESOLUTION" -framerate "$FRAMERATE" \
-f x11grab -i "$DISPLAY" \
-c:v libx264 -crf 35 -preset ultrafast -tune zerolatency \
-c:a aac -b:a 96k "$OUTPUT"
