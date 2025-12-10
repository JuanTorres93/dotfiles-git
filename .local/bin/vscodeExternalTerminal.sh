#!/usr/bin/env bash
# Abre Alacritty; entra en devcontainer si existe, si no usa shell del host

set -eu

HOST_SHELL="/usr/bin/fish"

PROJECT_DIR="$(pwd)"

alacritty -e bash -lc '
set -eu

PROJECT_DIR="'"$PROJECT_DIR"'"
HOST_SHELL="'"$HOST_SHELL"'"

PROJECT_NAME="$(basename "$PROJECT_DIR")"
WORKDIR="/workspaces/$PROJECT_NAME"

# Buscar devcontainer (label nueva y antigua)
CONTAINER_ID="$(docker ps -q --filter "label=devcontainer.local_folder=$PROJECT_DIR" | head -n1)"
if [ -z "$CONTAINER_ID" ]; then
  CONTAINER_ID="$(docker ps -q --filter "label=vsch.local.folder=$PROJECT_DIR" --filter "label=vsch.quality=stable" | head -n1)"
fi

# Si no hay devcontainer → shell normal del host en el proyecto
if [ -z "$CONTAINER_ID" ]; then
  echo "No se ha encontrado devcontainer. Shell normal del host."
  cd "$PROJECT_DIR"
  exec "$HOST_SHELL"
fi

# Usuario real del contenedor = dueño del workspace
DEV_USER="$(docker exec "$CONTAINER_ID" sh -lc \
  "stat -c '\''%U'\'' '\''$WORKDIR'\'' 2>/dev/null || echo root"
)"

# Entrar al contenedor
docker exec -it \
  --user "$DEV_USER" \
  --workdir "$WORKDIR" \
  "$CONTAINER_ID" \
  bash

echo
echo "Has salido del devcontainer. Vuelves al host."

cd "$PROJECT_DIR"
exec "$HOST_SHELL"
'
