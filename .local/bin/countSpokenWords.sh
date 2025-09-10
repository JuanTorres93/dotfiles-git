#!/usr/bin/env bash
set -euo pipefail

# Config
WPM=190
START_MARKER=""
SHOW_TIME=true

usage() {
  cat <<EOF
Usage: $(basename "$0") [-w WPM] [-s "START MARKER"] [--no-time] file1.md [file2.md ...]
  -w   Words per minute for duration estimate (default: $WPM)
  -s   Text that marks the start of the spoken script (e.g., "SCRIPT STARTS HERE")
       If not provided, tries to detect:
         - "SCRIPT STARTS HERE"
         - Heading starting with "# 2 - Hook"
  --no-time   Do not show time estimate
EOF
}

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -w) WPM="${2:-}"; shift 2 ;;
    -s) START_MARKER="${2:-}"; shift 2 ;;
    --no-time) SHOW_TIME=false; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

if [[ ${#ARGS[@]} -eq 0 ]]; then
  echo "Error: you must provide at least one file." >&2
  usage; exit 1
fi

process_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "File not found: $file" >&2
    echo "0"; return
  fi

  # 1) Trim everything before the spoken script
  awk -v m="$START_MARKER" '
    BEGIN{inspeech=0}
    {
      if (!inspeech) {
        if (m != "" && index($0, m)>0) {inspeech=1; next}
        if (m == "" && ($0 ~ /SCRIPT STARTS HERE/)) {inspeech=1; next}
        if (m == "" && ($0 ~ /^#[[:space:]]*2[[:space:]]*-[[:space:]]*Hook/)) {inspeech=1; next}
        next
      } else { print }
    }
  ' "$file" \
  | awk '
      # 2) Remove HTML comments <!-- ... --> including multiline
      BEGIN{incom=0}
      {
        line=$0
        while (1) {
          if (!incom) {
            start = index(line, "<!--")
            if (start==0) {break}
            end = index(substr(line, start+4), "-->")
            if (end>0) {
              pre = substr(line, 1, start-1)
              post = substr(line, start+4+end+2)
              line = pre post
            } else {
              line = substr(line, 1, start-1)
              incom=1
              break
            }
          } else {
            end = index(line, "-->")
            if (end==0) { line=""; break }
            line = substr(line, end+3)
            incom=0
          }
        }
        if (!incom && length(line)>0) print line
      }
    ' \
  | awk '
      # 3) Skip fenced code blocks (``` ... ```)
      BEGIN{incode=0}
      /^[[:space:]]*```/ {incode = !incode; next}
      incode {next}

      # 4) Skip markdown headings
      /^[[:space:]]*#/ {next}

      {print}
    ' \
  | sed -E 's/\[[^][]*\]//g' \
  | sed -E 's/[*`]+//g' \
  | sed -E 's#https?://[^ )>]+##g; s/[<>]//g; s/[[:space:]]+/ /g' \
  | awk 'NF>0' \
  | grep -oE "[[:alpha:][:digit:]ÁÉÍÓÚÜÑáéíóúüñ]+([\'’-][[:alpha:]ÁÉÍÓÚÜÑáéíóúüñ]+)*" \
  | wc -w
}

total_words=0
for f in "${ARGS[@]}"; do
  words=$(process_file "$f")
  total_words=$(( total_words + words ))
  if $SHOW_TIME; then
    secs=$(( words * 60 / WPM ))
    min=$(( secs / 60 ))
    sec=$(( secs % 60 ))
    printf "%s: %d words ~ %d:%02d min @ %d wpm\n" "$f" "$words" "$min" "$sec" "$WPM"
  else
    printf "%s: %d words\n" "$f" "$words"
  fi
done

if (( ${#ARGS[@]} > 1 )); then
  if $SHOW_TIME; then
    secs=$(( total_words * 60 / WPM ))
    min=$(( secs / 60 ))
    sec=$(( secs % 60 ))
    printf "TOTAL: %d words ~ %d:%02d min @ %d wpm\n" "$total_words" "$min" "$sec" "$WPM"
  else
    printf "TOTAL: %d words\n" "$total_words"
  fi
fi
