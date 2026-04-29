#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG ---
BASE_DIR="/home/juan/hdd/Buscar trabajo/Buscar trabajo full stack/Candidaturas"
CV_PATH="/home/juan/hdd/Buscar trabajo/CV/Fullstack/base/CV_Juan_Torres.pdf"
ODS_PATH="/home/juan/hdd/Buscar trabajo/Buscar trabajo full stack/SEGUIMIENTO.ods"
OFERTA_FILE="Oferta.md"   # nombre del archivo que abrirá vim
# ---------------

# Utilidad: lectura/escritura portapapeles (Wayland/X11/xdg)
clip_read() {
  if command -v xdg-clipboard >/dev/null 2>&1; then xdg-clipboard read
  elif [[ -n "${WAYLAND_DISPLAY-}" ]] && command -v wl-paste >/dev/null 2>&1; then wl-paste
  elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard -o
  else
    echo "No encuentro herramienta de portapapeles (instala xdg-clipboard o wl-clipboard o xclip)." >&2
    exit 1
  fi
}
clip_write() {
  if command -v xdg-clipboard >/dev/null 2>&1; then xdg-clipboard write
  elif [[ -n "${WAYLAND_DISPLAY-}" ]] && command -v wl-copy >/dev/null 2>&1; then wl-copy
  elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard
  else
    echo "No encuentro herramienta de portapapeles (instala xdg-clipboard o wl-clipboard o xclip)." >&2
    exit 1
  fi
}

# Sanitiza nombre para sistema de ficheros (mantiene espacios, quita barras y control)
sanitize_name() {
  local s="$1"
  s="${s//$'\r'/}"           # CR
  s="${s//$'\n'/ }"          # NL -> espacio
  s="${s//\//-}"             # / -> -
  s="${s//$'\t'/ }"          # tab -> espacio
  # recorta espacios extremos
  s="$(printf '%s' "$s" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"
  printf '%s' "$s"
}

# Calcula siguiente índice (01, 02, ... 09, 10, 11, ...)
next_index() {
  local max=0 n
  shopt -s nullglob
  for d in "$BASE_DIR"/*/ "$BASE_DIR"/* ; do
    d="${d%/}"
    bn="$(basename "$d")"
    if [[ "$bn" =~ ^([0-9]+)[[:space:]]-\  ]]; then
      n="${BASH_REMATCH[1]}"
      # quita ceros a la izquierda para comparar
      n=$((10#$n))
      (( n > max )) && max=$n
    fi
  done
  local next=$((max + 1))
  if (( next < 10 )); then
    printf '0%d' "$next"
  else
    printf '%d' "$next"
  fi
}

# Obtén nombre empresa (arg1 o portapapeles)
COMPANY_RAW="${1-}"
if [[ -z "${COMPANY_RAW}" ]]; then
  COMPANY_RAW="$(clip_read || true)"
fi
if [[ -z "${COMPANY_RAW//[[:space:]]/}" ]]; then
  echo "El portapapeles está vacío y no se pasó argumento. Copia el nombre de la empresa o pásalo como argumento." >&2
  exit 1
fi
COMPANY="$(sanitize_name "$COMPANY_RAW")"

IDX="$(next_index)"
DIR_NAME="${IDX} - ${COMPANY}"
DEST_DIR="${BASE_DIR}/${DIR_NAME}"

mkdir -p "$DEST_DIR"

# Copia CV
if [[ -f "$CV_PATH" ]]; then
  cp -n -- "$CV_PATH" "$DEST_DIR/"
else
  echo "AVISO: No se encontró el CV en $CV_PATH" >&2
fi

# Crea archivo de oferta si no existe
OFERTA_PATH="${DEST_DIR}/${OFERTA_FILE}"
if [[ ! -f "$OFERTA_PATH" ]]; then
  {
    echo "# Oferta - ${COMPANY}"
    echo
    echo
  } > "$OFERTA_PATH"
fi

# Prepara línea TSV para SEGUIMIENTO.ods en el portapapeles
# Columnas esperadas según tu extracto:
# 1: ID   2: Fecha(dd/mm/aa)  3: Empresa  4: Recruiter  5: Estado  6: Notas
FECHA="$(date +%d/%m/%y)"
ID="${IDX#0}"  # sin cero a la izquierda para coincidir con tu patrón de IDs en el .ods
RECRUITER=""
ESTADO="Enviado"
NOTAS="Carpeta: ${DIR_NAME}"

TSV_LINE="${ID}\t${FECHA}\t${COMPANY}\t${RECRUITER}\t${ESTADO}\t${NOTAS}"
# printf '%s' "$TSV_LINE" | clip_write
printf '%s' "$COMPANY" | clip_write

# Abre Thunar en la carpeta
if command -v thunar >/dev/null 2>&1; then
  thunar "$DEST_DIR" >/dev/null 2>&1 &
fi

# Abre el ODS para que pegues la línea (un solo paste)
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$ODS_PATH" >/dev/null 2>&1 &
fi

# Entra en la carpeta y abre Vim en el archivo de oferta
cd "$DEST_DIR"
vim "$OFERTA_FILE"

# Sugerencia opcional: si prefieres abrir vim en otra terminal, comenta la línea anterior
# y descomenta una de estas según lo que tengas instalado:
# if command -v xfce4-terminal >/dev/null 2>&1; then xfce4-terminal --working-directory="$DEST_DIR" -e "vim \"$OFERTA_FILE\"" & fi
# if command -v kitty >/dev/null 2>&1; then kitty -d "$DEST_DIR" vim "$OFERTA_FILE" & fi
# if command -v alacritty >/dev/null 2>&1; then alacritty --working-directory "$DEST_DIR" -e vim "$OFERTA_FILE" & fi
