#!/bin/bash

# Ruta al directorio .devcontainer
DEVCONTAINER_DIR=".devcontainer"
DEVCONTAINER_FILE="$DEVCONTAINER_DIR/devcontainer.json"

# Crear .devcontainer si no existe
mkdir -p "$DEVCONTAINER_DIR"

# Crear archivo devcontainer.json
cat > "$DEVCONTAINER_FILE" <<'EOF'
// For format details, see https://aka.ms/devcontainer.json. For config options, see the
// README at: https://github.com/devcontainers/templates/tree/main/src/docker-existing-dockerfile
{
	"name": "Existing Dockerfile",
	"build": {
		// Sets the run context to one level up instead of the .devcontainer folder.
		"context": "..",
		// Update the 'dockerFile' property if you aren't using the standard 'Dockerfile' filename.
		"dockerfile": "../Dockerfile"
	},

	// Features to add to the dev container. More info: https://containers.dev/features.
	// "features": {},

	// Use 'forwardPorts' to make a list of ports inside the container available locally.
	// "forwardPorts": [],

	// Uncomment the next line to run commands after the container is created.
	// "postCreateCommand": "cat /etc/os-release",
	"postCreateCommand": "npm install --save-dev eslint prettier",

	// Configure tool-specific properties.
	"customizations": {
		"vscode": {
			"extensions": [
				"dbaeumer.vscode-eslint",
				"esbenp.prettier-vscode",
				"naumovs.color-highlight",
				"Perkovec.emoji",
        		"42Crunch.vscode-openapi",
        		"Gruntfuggly.todo-tree",
				"formulahendry.auto-rename-tag"
			]
		}
	}

	// Uncomment to connect as an existing user other than the container default. More info: https://aka.ms/dev-containers-non-root.
	// "remoteUser": "devcontainer"
}
EOF

echo "✅ Archivo $DEVCONTAINER_FILE creado correctamente con extensiones: ESLint, Prettier, Color Highlight y Emoji (Perkovec)."
