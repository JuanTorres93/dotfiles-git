#!/bin/bash

# Root directory for the Sass structure
ROOT_DIR="sass"

# Declare structure of folders and files
declare -A folders_files=(
  ["abstracts"]="_variables.scss _mixins.scss _functions.scss"
  ["base"]="_reset.scss _typography.scss _base.scss"
  ["components"]="_buttons.scss _card.scss"
  ["layout"]="_header.scss _footer.scss _grid.scss"
  ["pages"]="_home.scss"
  ["themes"]="_theme.scss"
  ["vendors"]="_bootstrap.scss"
)

# Create root directory
mkdir -p "$ROOT_DIR"

# Create folders and files
for folder in "${!folders_files[@]}"; do
  mkdir -p "$ROOT_DIR/$folder"
  for file in ${folders_files[$folder]}; do
    touch "$ROOT_DIR/$folder/$file"
  done
done

# Write variables to _variables.scss (only required ones for now)
cat > "$ROOT_DIR/abstracts/_variables.scss" <<'EOL'
$neutral-bg: #ffffff;
$neutral-text: #1a1a1a;
$neutral-surface: #f2f2f2;

$color-secondary-light: #d0e6ff;
EOL

# Write content to _reset.scss
cat > "$ROOT_DIR/base/_reset.scss" <<'EOL'
@use "../abstracts/variables" as *;

/* Basix reset */
*,
*::after,
*::before {
  margin: 0;
  padding: 0;

  /* 
    Inherit box-sizing from parent, which will the the value
    defined in the body element
    */
  box-sizing: inherit;
}

html {
  // This defines what 1 rem is
  font-size: 62.5%; // 1rem = 10px, 10/16 = 50%
}

body {
  box-sizing: border-box;
  font-size: 1.6rem;
}
EOL

# Write updated content to _base.scss
cat > "$ROOT_DIR/base/_base.scss" <<'EOL'
@use "../abstracts/variables" as *;

body {
  box-sizing: border-box;
  font-size: 1.6rem;

  background-color: $neutral-bg;
  color: $neutral-text;
  font-family: "Inter", sans-serif;
  font-optical-sizing: auto;
  font-weight: 400;
  font-style: normal;
}

button,
input,
textarea {
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  font-style: inherit;
  color: inherit;
  border: none;
}

input,
textarea {
  background-color: $neutral-surface;
  outline: none;
}

button {
  cursor: pointer;

  &:focus {
    outline: none;
  }
}

::selection {
  // TODO change if needed when updated color palette
  background-color: $color-secondary-light;
  color: $neutral-text;
}
EOL

# Create main.scss file
MAIN_FILE="$ROOT_DIR/main.scss"
cat > "$MAIN_FILE" <<EOL
// Abstracts
@use 'abstracts/variables';
@use 'abstracts/mixins';
@use 'abstracts/functions';

// Base
@use 'base/reset';
@use 'base/typography';
@use 'base/base';

// Layout
@use 'layout/header';
@use 'layout/footer';
@use 'layout/grid';

// Components
@use 'components/buttons';
@use 'components/card';

// Pages
@use 'pages/home';

// Themes
@use 'themes/theme';

// Vendors
@use 'vendors/bootstrap';
EOL

echo "✅ Estructura Sass generada en ./$ROOT_DIR con contenido actualizado en reset, base y variables"