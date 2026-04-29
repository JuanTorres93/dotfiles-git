#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# USO:
#   ./candidaturaPersonalizada.sh -dev -esp
#   ./candidaturaPersonalizada.sh -dev -eng
#   ./candidaturaPersonalizada.sh -ind -esp
#   ./candidaturaPersonalizada.sh -ind -eng
# ============================================================

OFERTA_FILE="Oferta.md"

PROFILE=""
LANG_FLAG=""

for arg in "$@"; do
  case "$arg" in
    -dev|-ind)
      PROFILE="$arg"
      ;;
    -esp|-eng)
      LANG_FLAG="$arg"
      ;;
    *)
      echo "Argumento no reconocido: $arg" >&2
      echo "Uso: $(basename "$0") -dev|-ind -esp|-eng" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$PROFILE" || -z "$LANG_FLAG" ]]; then
  echo "Uso: $(basename "$0") -dev|-ind -esp|-eng" >&2
  exit 1
fi

# ---------------- CONFIG POR PERFIL ----------------

case "$PROFILE" in
  -dev)
    SEARCH_BASE_DIR="/home/juan/hdd/Buscar trabajo/Buscar trabajo full stack"
    CV_BASE_DIR="/home/juan/hdd/Buscar trabajo/CV/Fullstack/base"
    COVER_BASE_DIR="/home/juan/hdd/Buscar trabajo/Carta presentacion base/Full stack"
    ;;
  -ind)
    SEARCH_BASE_DIR="/home/juan/hdd/Buscar trabajo/Buscar trabajo industrial"
    CV_BASE_DIR="/home/juan/hdd/Buscar trabajo/CV/Industrial/base"
    COVER_BASE_DIR="/home/juan/hdd/Buscar trabajo/Carta presentacion base/Industrial"
    ;;
esac

BASE_DIR="${SEARCH_BASE_DIR}/Candidaturas"
ODS_PATH="${SEARCH_BASE_DIR}/SEGUIMIENTO.ods"

# ---------------- CONFIG POR IDIOMA ----------------

case "$LANG_FLAG" in
  -esp)
    CV_FILE="CV_Juan_Torres_ESP.odt"
    COVER_FILE="juan_torres_cover_letter_ESP.odt"
    CV_DEST_PREFIX="Juan Torres - CV"
    COVER_DEST_PREFIX="Juan Torres - Carta presentacion"
    ;;
  -eng)
    CV_FILE="CV_Juan_Torres_ENG.odt"
    COVER_FILE="juan_torres_cover_letter_ENG.odt"
    CV_DEST_PREFIX="Juan Torres - Resume"
    COVER_DEST_PREFIX="Juan Torres - Cover letter"
    ;;
esac

CV_ODT_PATH="${CV_BASE_DIR}/${CV_FILE}"
COVER_LETTER_PATH="${COVER_BASE_DIR}/${COVER_FILE}"

# ---------------- UTILIDADES ----------------

clip_read() {
  if command -v xdg-clipboard >/dev/null 2>&1; then
    xdg-clipboard read
  elif [[ -n "${WAYLAND_DISPLAY-}" ]] && command -v wl-paste >/dev/null 2>&1; then
    wl-paste
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -o
  else
    echo "No encuentro herramienta de portapapeles. Instala xdg-clipboard, wl-clipboard o xclip." >&2
    exit 1
  fi
}

clip_write() {
  if command -v xdg-clipboard >/dev/null 2>&1; then
    xdg-clipboard write
  elif [[ -n "${WAYLAND_DISPLAY-}" ]] && command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  else
    echo "No encuentro herramienta de portapapeles. Instala xdg-clipboard, wl-clipboard o xclip." >&2
    exit 1
  fi
}

sanitize_name() {
  local s="$1"

  s="${s//$'\r'/}"
  s="${s//$'\n'/ }"
  s="${s//$'\t'/ }"

  # ñ / Ñ
  s="${s//ñ/n}"
  s="${s//Ñ/N}"

  # barras problemáticas
  s="${s//\//-}"
  s="${s//\\/ - }"

  # caracteres de control
  s="$(printf '%s' "$s" | tr -d '[:cntrl:]')"

  # espacios múltiples -> uno
  s="$(printf '%s' "$s" | sed -E 's/[[:space:]]+/ /g')"

  # recortar espacios
  s="$(printf '%s' "$s" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"

  printf '%s' "$s"
}

next_index() {
  local max=0 n bn d

  shopt -s nullglob

  for d in "$BASE_DIR"/*/ "$BASE_DIR"/*; do
    d="${d%/}"
    [[ -e "$d" ]] || continue

    bn="$(basename "$d")"

    if [[ "$bn" =~ ^([0-9]+)[[:space:]]-\  ]]; then
      n="${BASH_REMATCH[1]}"
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

open_libreoffice_bg() {
  local file="$1"

  if command -v libreoffice >/dev/null 2>&1; then
    libreoffice "$file" >/dev/null 2>&1 &
  else
    echo "AVISO: LibreOffice no está instalado o no se encuentra en PATH." >&2
  fi
}

open_libreoffice_blocking() {
  local file="$1"

  if command -v libreoffice >/dev/null 2>&1; then
    libreoffice "$file"
  else
    echo "AVISO: LibreOffice no está instalado o no se encuentra en PATH." >&2
  fi
}

copy_and_open_document() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [[ -f "$src" ]]; then
    cp -- "$src" "$dest"
    open_libreoffice_blocking "$dest"
  else
    echo "AVISO: No se encontró ${label}: $src" >&2
  fi
}

# ---------------- VALIDACIONES ----------------

mkdir -p "$BASE_DIR"

if [[ ! -d "$BASE_DIR" ]]; then
  echo "No existe la carpeta de candidaturas: $BASE_DIR" >&2
  exit 1
fi

if [[ ! -f "$ODS_PATH" ]]; then
  echo "AVISO: No se encontró el archivo de seguimiento: $ODS_PATH" >&2
fi

# ---------------- EMPRESA DESDE PORTAPAPELES ----------------

COMPANY_RAW="$(clip_read || true)"

if [[ -z "${COMPANY_RAW//[[:space:]]/}" ]]; then
  echo "El portapapeles está vacío. Copia el nombre de la empresa antes de ejecutar el script." >&2
  exit 1
fi

COMPANY="$(sanitize_name "$COMPANY_RAW")"

if [[ -z "$COMPANY" ]]; then
  echo "El nombre de empresa queda vacío tras sanitizarlo." >&2
  exit 1
fi

# ---------------- CREAR CANDIDATURA ----------------

IDX="$(next_index)"
DIR_NAME="${IDX} - ${COMPANY}"
DEST_DIR="${BASE_DIR}/${DIR_NAME}"

mkdir -p "$DEST_DIR"

CV_DEST_NAME="${CV_DEST_PREFIX} - ${COMPANY}.odt"
COVER_DEST_NAME="${COVER_DEST_PREFIX} - ${COMPANY}.odt"

FECHA="$(date +%d/%m/%y)"
ID="${IDX#0}"
RECRUITER=""
ESTADO="Enviado"
NOTAS="Carpeta: ${DIR_NAME}"

TSV_LINE="$(printf '%s\t%s\t%s\t%s\t%s\t%s' "$ID" "$FECHA" "$COMPANY" "$RECRUITER" "$ESTADO" "$NOTAS")"

# Para copiar la fila completa del seguimiento, cambia la línea activa por la de TSV_LINE.
printf '%s' "$COMPANY" | clip_write
# printf '%s' "$TSV_LINE" | clip_write

# Abrir seguimiento
if [[ -f "$ODS_PATH" ]]; then
  LANG=es_ES.UTF-8 LC_TIME=es_ES.UTF-8 open_libreoffice_bg "$ODS_PATH"
fi

# Crear Oferta.md
OFERTA_PATH="${DEST_DIR}/${OFERTA_FILE}"

if [[ ! -f "$OFERTA_PATH" ]]; then
  {
    echo "# Oferta - ${COMPANY}"
    echo
    echo
  } > "$OFERTA_PATH"
fi

cd "$DEST_DIR"
vim "$OFERTA_FILE"

# ---------------- CV Y CARTA ----------------

copy_and_open_document "$CV_ODT_PATH" "$DEST_DIR/$CV_DEST_NAME" "el CV base"
copy_and_open_document "$COVER_LETTER_PATH" "$DEST_DIR/$COVER_DEST_NAME" "la carta de presentación base"

# ---------------- ABRIR CARPETA ----------------

if command -v thunar >/dev/null 2>&1; then
  thunar "$DEST_DIR" >/dev/null 2>&1 &
fi