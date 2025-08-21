#!/usr/bin/env bash
set -euo pipefail

# resolve-ready.sh — Convierte vídeos a MOV (ProRes 422 + PCM) para DaVinci Resolve en Linux
# Uso:
#   ./resolve-ready.sh archivo1.mp4 archivo2.mkv ...
#   ./resolve-ready.sh /ruta/a/carpeta        # procesa extensiones comunes dentro de la carpeta
#
# Opcional:
#   TARGET_CODEC=prores   # (por defecto) ProRes 422
#   TARGET_CODEC=dnxhr    # usa DNxHR HQ para >=2K y DNxHD para <=1080p

TARGET_CODEC="${TARGET_CODEC:-prores}"

has_cmd () { command -v "$1" >/dev/null 2>&1; }
if ! has_cmd ffmpeg || ! has_cmd ffprobe; then
  echo "❌ Necesitas ffmpeg y ffprobe en PATH." >&2
  exit 1
fi

is_video_file () {
  local f="${1,,}" # minúsculas
  case "$f" in
    *.mp4|*.mov|*.mkv|*.avi|*.m4v|*.mts|*.m2ts|*.ts|*.webm|*.3gp) return 0 ;;
    *) return 1 ;;
  esac
}

gather_inputs () {
  if [ "$#" -eq 0 ]; then
    echo "❌ Debes pasar archivos o una carpeta." >&2
    exit 1
  fi

  local inputs=()
  if [ -d "$1" ]; then
    while IFS= read -r -d '' f; do
      inputs+=("$f")
    done < <(find "$1" -type f \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.m4v' -o -iname '*.mts' -o -iname '*.m2ts' -o -iname '*.ts' -o -iname '*.webm' -o -iname '*.3gp' \) -print0)
  else
    for a in "$@"; do
      if [ -f "$a" ] && is_video_file "$a"; then
        inputs+=("$a")
      fi
    done
  fi
  printf '%s\n' "${inputs[@]}"
}

get_stream_field () {
  local file="$1" stream="$2" field="$3"
  ffprobe -v error -select_streams "$stream" \
    -show_entries "stream=$field" -of default=nk=1:nw=1 "$file" 2>/dev/null | head -n1 || true
}

process_file () {
  local in="$1"
  local base="${in##*/}"
  local name="${base%.*}"
  local outdir="resolve_ready"
  mkdir -p "$outdir"
  local out="$outdir/$name.mov"

  echo "▶ Procesando: $in"

  local vcodec acodec width height fps
  vcodec="$(get_stream_field "$in" v:0 codec_name)"
  acodec="$(get_stream_field "$in" a:0 codec_name)"
  width="$(get_stream_field "$in" v:0 width)"
  height="$(get_stream_field "$in" v:0 height)"
  fps="$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate \
        -of default=nk=1:nw=1 "$in" 2>/dev/null | head -n1)"
  fps="${fps:-0/0}"

  # Normalizamos nombres de códec de vídeo "compatibles ya"
  local v_is_prores="no"
  local v_is_dnx="no"
  case "${vcodec,,}" in
    prores|prores_ks|apcn|apch|apco|apcs|ap4h) v_is_prores="yes" ;;
  esac
  case "${vcodec,,}" in
    dnxhd|dnxhr|avdn) v_is_dnx="yes" ;;
  esac

  # ¿Audio PCM ya compatible?
  local a_is_pcm="no"
  case "${acodec,,}" in
    pcm_s16le|pcm_s24le|pcm_s32le|pcm_s16be|pcm_s24be|pcm_s32be) a_is_pcm="yes" ;;
  esac

  # Decisiones:
  if { [ "$v_is_prores" = "yes" ] || [ "$v_is_dnx" = "yes" ]; } && [ "$a_is_pcm" = "yes" ]; then
    # Todo compatible: solo remux (copia sin recomprimir) para asegurar .mov
    ffmpeg -hide_banner -stats -y -i "$in" -c copy "$out"
    echo "✅ Remux: $out"
    return
  fi

  if { [ "$v_is_prores" = "yes" ] || [ "$v_is_dnx" = "yes" ]; } && [ "$a_is_pcm" = "no" ]; then
    # Vídeo ok, solo arreglar audio a PCM
    ffmpeg -hide_banner -stats -y -i "$in" -c:v copy -c:a pcm_s16le "$out"
    echo "✅ Audio→PCM, vídeo copiado: $out"
    return
  fi

  # Necesita transcodificar vídeo (y pondremos audio PCM)
  if [ "${TARGET_CODEC}" = "dnxhr" ]; then
    # DNxHR para >=2K, DNxHD para <=1080p
    if [ -n "$width" ] && [ "$width" -ge 2000 ]; then
      ffmpeg -hide_banner -stats -y -i "$in" \
        -c:v dnxhr -profile:v dnxhr_hq -pix_fmt yuv422p \
        -r "$fps" -c:a pcm_s16le "$out"
      echo "✅ DNxHR HQ + PCM: $out"
    else
      # DNxHD requiere bitrate acorde a FPS/res; usamos valores seguros
      # 1080p25≈36M, 1080p30≈45M; si es 720p, bajamos a 90M/60? Usamos 36M por defecto.
      local br="36M"
      case "$fps" in
        30000/1001|30/1|30) br="45M" ;;
      esac
      ffmpeg -hide_banner -stats -y -i "$in" \
        -c:v dnxhd -b:v "$br" -pix_fmt yuv422p \
        -r "$fps" -c:a pcm_s16le "$out"
      echo "✅ DNxHD ($br) + PCM: $out"
    fi
  else
    # ProRes 422 (profile 2) + PCM — sencillo y muy compatible
    ffmpeg -hide_banner -stats -y -i "$in" \
      -c:v prores_ks -profile:v 2 -pix_fmt yuv422p10le \
      -r "$fps" -c:a pcm_s16le "$out"
    echo "✅ ProRes 422 + PCM: $out"
  fi
}

main () {
  mapfile -t inputs < <(gather_inputs "$@")
  if [ "${#inputs[@]}" -eq 0 ]; then
    echo "❌ No se encontraron archivos de vídeo válidos." >&2
    exit 1
  fi
  for f in "${inputs[@]}"; do
    process_file "$f"
  done
  echo "🎉 Listo. Archivos en ./resolve_ready/"
}

main "$@"
