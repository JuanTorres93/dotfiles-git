#!/bin/bash

# 📺 Configuración de video
RESOLUTION="2560x1440"
FRAMERATE=30
DISPLAY=":0.0"

# 🔊 Detectar el monitor de la salida de audio predeterminada
DEFAULT_SINK=$(pactl info | awk -F': ' '/Default Sink/ {print $2}')
AUDIO_SOURCE="${DEFAULT_SINK}.monitor"

# 🚨 Verificar si existe la fuente de audio
if ! pactl list short sources | grep -q "$AUDIO_SOURCE"; then
  echo "❌ No se encontró la fuente de audio del sistema para el sink predeterminado: $AUDIO_SOURCE"
  exit 1
fi

# 📁 Nombre de archivo de salida
if [ -n "$1" ]; then
  BASENAME="${1%.mp4}"
  OUTPUT="${BASENAME}.mp4"
else
  OUTPUT="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
fi

# 🎥 Comando de grabación con ffmpeg (pantalla + audio del sistema)
ffmpeg \
-f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$DISPLAY" \
-f pulse -i "$AUDIO_SOURCE" \
-c:v libx264 -preset veryfast -crf 18 \
-c:a aac -b:a 192k \
"$OUTPUT"
