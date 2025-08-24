#!/bin/bash

# ===== Settings =====
FRAMERATE=25
DISPLAY=":0.0"
TARGET_W=1920
TARGET_H=1080

# Detecta resolución actual de la pantalla (xrandr)
SRC_RES=$(xrandr | awk '/\*/ {print $1; exit}')
# Fallback si xrandr no devuelve nada
[ -z "$SRC_RES" ] && SRC_RES=$(xdpyinfo | awk '/dimensions:/ {print $2}')

# Nombre de salida
if [ -n "$1" ]; then
  BASENAME="${1%.mp4}"
  OUTPUT="${BASENAME}.mp4"
else
  OUTPUT="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
fi

# Graba pantalla completa y reescala a 1080p con parámetros "amigables" para tablets
ffmpeg \
-f x11grab -framerate "$FRAMERATE" -video_size "$SRC_RES" -i "$DISPLAY" \
-vf "scale=${TARGET_W}:${TARGET_H}" \
-c:v libx264 -crf 28 -preset veryfast -tune zerolatency \
-profile:v high -level 4.0 -pix_fmt yuv420p \
-maxrate 5M -bufsize 10M \
-c:a aac -b:a 128k -ar 48000 \
-movflags +faststart \
"$OUTPUT"
