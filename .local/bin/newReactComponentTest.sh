#!/usr/bin/env bash
# Uso: ./newReactComponentTest.sh NombreComponente
set -euo pipefail

if [ "${1-}" = "" ]; then
  echo "Uso: $0 NombreComponente (por ejemplo: $0 MealReminder)"
  exit 1
fi

# Nombre del componente en PascalCase
COMPONENT_RAW="$1"

# Detectar carpeta de tests
if [ -d "__tests__" ]; then
  TEST_DIR="__tests__"
else
  TEST_DIR="__tests__"
  mkdir -p "$TEST_DIR"
fi

TEST_TSX_PATH="$TEST_DIR/${COMPONENT_RAW}.test.tsx"

# Evitar sobreescribir
if [ -e "$TEST_TSX_PATH" ]; then
  echo "❌ Error: el archivo '$TEST_TSX_PATH' ya existe. Cancelo para no sobreescribir."
  exit 1
fi

# ---- Template Test ----
cat > "$TEST_TSX_PATH" <<'EOF'
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

// TODO (if needed) import an AppRepo
// TODO (if needed) import repo memory implementation

// const repo = AppsRepo as MemoryRepo;

import { TEST_USER_ID } from '@/../tests/mocks/nextjs';

// TODO (if needed) import create mock functions
// import { createMockDayWithMeal } from '../../../../../tests/mocks/days';

import COMPONENT_TO_TEST from '../COMPONENT_TO_TEST';

async function setup() {
  // TODO: create mocks

  render(<COMPONENT_TO_TEST />);

  // TODO: adjust selectors
  const element = screen.getByText('example');

  return { element };
}

describe('COMPONENT_TO_TEST', () => {
  // afterEach(() => {
  //   repo.clearForTesting();
  // });

  it('should fail because it is a scaffolded test', async () => {
    const { element } = await setup();

    expect(false).toBe(true);
  });
});
EOF

# ---- Reemplazos ----
sed -i "s/\bCOMPONENT_TO_TEST\b/${COMPONENT_RAW}/g" "$TEST_TSX_PATH"

echo "✅ Creado test scaffold:"
echo "  - $TEST_TSX_PATH"