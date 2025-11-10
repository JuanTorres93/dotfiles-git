#!/usr/bin/env bash
# Uso: ./newEntity.sh NombreEntidad
set -euo pipefail

if [ "${1-}" = "" ]; then
  echo "Uso: $0 NombreEntidad (por ejemplo: $0 Product)"
  exit 1
fi

# Nombre de la entidad en PascalCase
ENTITY_RAW="$1"

# Carpeta en minúsculas
DIR_NAME="$(echo "$ENTITY_RAW" | tr '[:upper:]' '[:lower:]')"

# Nombre en camelCase para variables
ENTITY_CAMEL="$(echo "${ENTITY_RAW:0:1}" | tr '[:upper:]' '[:lower:]')${ENTITY_RAW:1}"

ENTITY_TS_PATH="$DIR_NAME/${ENTITY_RAW}.ts"
TEST_TS_PATH="$DIR_NAME/__tests__/${ENTITY_RAW}.test.ts"

mkdir -p "$DIR_NAME/__tests__"

# ---- Template Entity ----
cat > "$ENTITY_TS_PATH" <<'EOF'
import { ValidationError } from '../common/errors';
import { handleCreatedAt, handleUpdatedAt } from '../common/utils';
import { validateNonEmptyString } from '../common/validation';

export type EntityProps = {
  id: string;
  name: string;
  // More props
  createdAt: Date;
  updatedAt: Date;
};

export class Entity {
  private constructor(private readonly props: EntityProps) {}

  static create(props: EntityProps): Entity {
    validateNonEmptyString(props.id, 'Entity id');
    validateNonEmptyString(props.name, 'Entity name');

    // Validation

    props.createdAt = handleCreatedAt(props.createdAt);
    props.updatedAt = handleUpdatedAt(props.updatedAt);

    return new Entity(props);
  }

  // Getters
  get id() {
    return this.props.id;
  }

  get name() {
    return this.props.name;
  }

  get createdAt() {
    return this.props.createdAt;
  }

  get updatedAt() {
    return this.props.updatedAt;
  }
}
EOF

# ---- Template Test ----
cat > "$TEST_TS_PATH" <<'EOF'
import { beforeEach, describe, expect, it } from 'vitest';

import { Entity, EntityProps } from '../Entity';
import { ValidationError } from '@/domain/common/errors';

describe('Entity', () => {
  let entity: Entity;
  let validEntityProps: EntityProps;

  beforeEach(() => {
    validEntityProps = {
      id: '1',
      name: 'Cake',
      // More props
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    entity = Entity.create(validEntityProps);
  });

  it('should create a valid entity', () => {
    expect(entity).toBeInstanceOf(Entity);
  });
});
EOF

# ---- Reemplazos ----
# Entity -> NombreEntidad
sed -i "s/\bEntityProps\b/${ENTITY_RAW}Props/g" "$ENTITY_TS_PATH" "$TEST_TS_PATH"
sed -i "s/\bEntity\b/${ENTITY_RAW}/g" "$ENTITY_TS_PATH" "$TEST_TS_PATH"

# entity -> nombreEntidad
sed -i "s/\bentity\b/${ENTITY_CAMEL}/g" "$TEST_TS_PATH"
# validEntityProps -> validNombreEntidadProps
sed -i "s/\bvalidEntityProps\b/valid${ENTITY_RAW}Props/g" "$TEST_TS_PATH"

echo "✅ Creado scaffolding:"
echo "  - $ENTITY_TS_PATH"
echo "  - $TEST_TS_PATH"
