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

echo "✅ Estructura Sass generada en ./$ROOT_DIR"
