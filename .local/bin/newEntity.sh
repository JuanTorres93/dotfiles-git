#!/usr/bin/env bash
# Uso: ./newEntity.sh NombreEntidad
set -euo pipefail

if [ "${1-}" = "" ]; then
  echo "Uso: $0 NombreEntidad (por ejemplo: $0 WorkoutLine)"
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

# Evitar sobreescribir cosas por accidente
for path in "$ENTITY_TS_PATH" "$TEST_TS_PATH"; do
  if [ -e "$path" ]; then
    echo "❌ Error: el archivo '$path' ya existe. Cancelo para no sobreescribir."
    exit 1
  fi
done

mkdir -p "$DIR_NAME/__tests__"

# ---- Template Entity ----
cat > "$ENTITY_TS_PATH" <<'EOF'
import { ValidationError } from '../../common/errors';
import { handleCreatedAt, handleUpdatedAt } from '../../common/utils';

export type EntityCreateProps = {
  id: string;
  name: string;
  // More props
  createdAt: Date;
  updatedAt: Date;
};

export type EntityProps = {
  id: string; // TODO change to Value Object
  name: string; // TODO change to Value Object
  // More props
  createdAt: Date;
  updatedAt: Date;
};

export class Entity {
  private constructor(private readonly props: EntityProps) {}

  static create(props: EntityCreateProps): Entity {
    // Validation

    const entityProps: EntityProps = {
      // TODO more props validated with Value Objects
      createdAt: handleCreatedAt(props.createdAt),
      updatedAt: handleUpdatedAt(props.updatedAt),
    };

    return new Entity(entityProps);
  }

  // Getters
  get id() {
    // TODO include .value when changing to Value Object
    return this.props.id;
  }

  get name() {
    // TODO include .value when changing to Value Object
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
import { Entity, EntityCreateProps } from '../Entity';
import { ValidationError } from '@/domain/common/errors';
import * as vp from '@/../tests/createProps';

describe('Entity', () => {
  let entity: Entity;
  let validEntityProps: EntityCreateProps;

  beforeEach(() => {
    validEntityProps = {
      ...vp.validEntityProps
    };
    entity = Entity.create(validEntityProps);
  });

  it('should create a valid entity', () => {
    expect(entity).toBeInstanceOf(Entity);
  });
});
EOF

# ---- Reemplazos ----
# Tipos
sed -i "s/\bEntityCreateProps\b/${ENTITY_RAW}CreateProps/g" "$ENTITY_TS_PATH" "$TEST_TS_PATH"
sed -i "s/\bEntityProps\b/${ENTITY_RAW}Props/g" "$ENTITY_TS_PATH"

# Clase / nombre de entidad
sed -i "s/\bEntity\b/${ENTITY_RAW}/g" "$ENTITY_TS_PATH" "$TEST_TS_PATH"

# Variables en los tests
sed -i "s/\bentity\b/${ENTITY_CAMEL}/g" "$TEST_TS_PATH"
sed -i "s/\bvalidEntityProps\b/valid${ENTITY_RAW}Props/g" "$TEST_TS_PATH"

# Mensaje del test: 'valid entity' -> 'valid workoutLine'
sed -i "s/valid entity/valid ${ENTITY_CAMEL}/g" "$TEST_TS_PATH"

echo "✅ Creado scaffolding:"
echo "  - $ENTITY_TS_PATH"
echo "  - $TEST_TS_PATH"
