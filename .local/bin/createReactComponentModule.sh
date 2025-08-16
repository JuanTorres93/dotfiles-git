#!/bin/bash

# Script to generate React components with .jsx and .module.scss files
# Usage: ./createReactComponentModule.sh ComponentName

# Check if a parameter is provided
if [ $# -eq 0 ]; then
    echo "Error: You must provide a component name"
    echo "Usage: $0 ComponentName"
    exit 1
fi

# Get the component name from the first parameter
COMPONENT_NAME="$1"

# Check that the name is not empty
if [ -z "$COMPONENT_NAME" ]; then
    echo "Error: Component name cannot be empty"
    exit 1
fi

# Create the component folder
if [ -d "$COMPONENT_NAME" ]; then
    echo "Error: Folder '$COMPONENT_NAME' already exists"
    exit 1
fi

mkdir "$COMPONENT_NAME"
echo "Folder '$COMPONENT_NAME' created"

# Create the JSX file
JSX_FILE="$COMPONENT_NAME/$COMPONENT_NAME.jsx"
cat > "$JSX_FILE" << EOF
import styles from './$COMPONENT_NAME.module.scss'

function $COMPONENT_NAME() {
  return (
    <div className={styles.$COMPONENT_NAME}>
      $COMPONENT_NAME
    </div>
  )
}

export default $COMPONENT_NAME;
EOF

echo "File '$JSX_FILE' created"

# Create the SCSS file
SCSS_FILE="$COMPONENT_NAME/$COMPONENT_NAME.module.scss"
cat > "$SCSS_FILE" << EOF
@use "../../../variables" as *;

.$COMPONENT_NAME {
    
}
EOF

echo "File '$SCSS_FILE' created"