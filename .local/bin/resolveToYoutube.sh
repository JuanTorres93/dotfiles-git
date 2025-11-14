#!/usr/bin/env bash

# Uso: resolveToYoutube.sh "video.mov"

INPUT="$1"

if [ -z "$INPUT" ]; then
  echo "Uso: $0 archivo_entrada.mov"
  exit 1
fi

# Quita la extensión del archivo
BASENAME="${INPUT%.*}"

# Nombre de salida: mismo nombre + 'Youtube.mp4'
OUTPUT="${BASENAME}Youtube.mp4"

ffmpeg -i "$INPUT" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k "$OUTPUT"