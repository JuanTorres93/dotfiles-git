#!/bin/bash

# Usage:
#   ./videoToOdysee.sh input.ext
#   ./videoToOdysee.sh   (procesa todos los vídeos de la carpeta)

convert_video() {
    input="$1"
    # Quita extensión y añade sufijo -odysee.mp4
    output="${input%.*}-odysee.mp4"

    echo "Convirtiendo: $input -> $output"
    ffmpeg -i "$input" -c:v libx264 -b:v 8M -preset fast -c:a aac -b:a 192k -movflags +faststart "$output"
}

if [ $# -eq 0 ]; then
    # Sin argumentos → procesa todos los vídeos comunes
    for f in *.mov *.MOV *.mp4 *.MP4 *.mkv *.MKV *.avi *.AVI *.flv *.FLV *.wmv *.WMV *.m4v *.M4V; do
        [ -e "$f" ] || continue  # evita error si no hay de esa extensión
        convert_video "$f"
    done
else
    # Con argumento → procesa solo ese archivo
    convert_video "$1"
fi
