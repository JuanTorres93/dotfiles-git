#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG ---
BASE_DIR="/home/juan/hdd/Buscar trabajo/Buscar trabajo full stack/Candidaturas"
ODS_PATH="/home/juan/hdd/Buscar trabajo/Buscar trabajo full stack/SEGUIMIENTO.ods"
OFERTA_FILE="Oferta.md"   # nombre del archivo que abrirá vim
# ---------------

# --- PARÁMETRO IDIOMA (OBLIGATORIO) ---
LANG="${1-}"
if [[ "$LANG" != "-esp" && "$LANG" != "-eng" ]]; then
  echo "Uso: $(basename "$0") -esp|-eng" >&2
  exit 1
fi

# Selección de rutas y prefijos según idioma
case "$LANG" in
  -esp)
    CV_ODT_PATH="/home/juan/hdd/Buscar trabajo/CV/Fullstack/base/CV_Juan_Torres_ESP.odt"
    COVER_LETTER_PATH="/home/juan/hdd/Buscar trabajo/Carta presentacion base/juan_torres_cover_letter_ESP.odt"
    CV_DEST_PREFIX="CV_Juan_Torres"
    COVER_DEST_PREFIX="Carta_presentacion_Juan_Torres"
    ;;
  -eng)
    CV_ODT_PATH="/home/juan/hdd/Buscar trabajo/CV/Fullstack/base/CV_Juan_Torres_ENG.odt"
    COVER_LETTER_PATH="/home/juan/hdd/Buscar trabajo/Carta presentacion base/juan_torres_cover_letter_ENG.odt"
    CV_DEST_PREFIX="Resume_Juan_Torres"
    COVER_DEST_PREFIX="Cover_letter_Juan_Torres"
    ;;
esac

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
  local max=0 n bn
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

# --- NOMBRE DE LA EMPRESA DESDE PORTAPAPELES (OBLIGATORIO) ---

COMPANY_RAW="$(clip_read || true)"
if [[ -z "${COMPANY_RAW//[[:space:]]/}" ]]; then
  echo "El portapapeles está vacío. Copia el nombre de la empresa antes de ejecutar el script." >&2
  exit 1
fi
COMPANY="$(sanitize_name "$COMPANY_RAW")"

# Nombres destino según idioma + empresa
CV_DEST_NAME="${CV_DEST_PREFIX} - ${COMPANY}.odt"
COVER_DEST_NAME="${COVER_DEST_PREFIX} - ${COMPANY}.odt"

# 1) Crear carpeta de la candidatura
IDX="$(next_index)"
DIR_NAME="${IDX} - ${COMPANY}"
DEST_DIR="${BASE_DIR}/${DIR_NAME}"
mkdir -p "$DEST_DIR"

# 2) SEGUIMIENTO justo después de crear la carpeta
# Columnas: 1: ID  2: Fecha(dd/mm/aa)  3: Empresa  4: Recruiter  5: Estado  6: Notas
FECHA="$(date +%d/%m/%y)"
ID="${IDX#0}"  # sin cero a la izquierda
RECRUITER=""
ESTADO="Enviado"
NOTAS="Carpeta: ${DIR_NAME}"

TSV_LINE="${ID}\t${FECHA}\t${COMPANY}\t${RECRUITER}\t${ESTADO}\t${NOTAS}"

# Mantienes el mismo flujo: nombre empresa en el portapapeles
# (Si quisieras volver al TSV solo hay que descomentar la línea de TSV)
# printf '%s' "$TSV_LINE" | clip_write
printf '%s' "$COMPANY" | clip_write

# Abre el ODS para que pegues la info
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$ODS_PATH" >/dev/null 2>&1 &
fi

# 3) Crear archivo de oferta
OFERTA_PATH="${DEST_DIR}/${OFERTA_FILE}"
if [[ ! -f "$OFERTA_PATH" ]]; then
  {
    echo "# Oferta - ${COMPANY}"
    echo
    echo
  } > "$OFERTA_PATH"
fi

# Entra en la carpeta y abre Vim en el archivo de oferta
cd "$DEST_DIR"
vim "$OFERTA_FILE"

# --- DESPUÉS DE CERRAR VIM: CV Y CARTA ---

# 4) Copiar CV .odt (según idioma) y abrirlo con LibreOffice, bloqueando
if [[ -f "$CV_ODT_PATH" ]]; then
  cp -- "$CV_ODT_PATH" "$DEST_DIR/$CV_DEST_NAME"
  if command -v libreoffice >/dev/null 2>&1; then
    libreoffice "$DEST_DIR/$CV_DEST_NAME"
  else
    echo "AVISO: LibreOffice no está instalado o no se encuentra en PATH. No se pudo abrir el CV." >&2
  fi
else
  echo "AVISO: No se encontró el CV .odt en $CV_ODT_PATH" >&2
fi

# 5) Copiar carta de presentación .odt (según idioma) y abrirla con LibreOffice, bloqueando
if [[ -f "$COVER_LETTER_PATH" ]]; then
  cp -- "$COVER_LETTER_PATH" "$DEST_DIR/$COVER_DEST_NAME"
  if command -v libreoffice >/dev/null 2>&1; then
    libreoffice "$DEST_DIR/$COVER_DEST_NAME"
  else
    echo "AVISO: LibreOffice no está instalado o no se encuentra en PATH. No se pudo abrir la carta de presentación." >&2
  fi
else
  echo "AVISO: No se encontró la carta de presentación en $COVER_LETTER_PATH" >&2
fi

# 6) Ahora sí, abrir Thunar en la carpeta de la candidatura
if command -v thunar >/dev/null 2>&1; then
  thunar "$DEST_DIR" >/dev/null 2>&1 &
fi
