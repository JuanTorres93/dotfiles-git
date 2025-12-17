#!/usr/bin/env bash
# Uso: ./newUsecase.sh NombreCasoDeUso (por ejemplo: ./newUsecase.sh GetAssembledDayById)
set -euo pipefail

if [ "${1-}" = "" ]; then
  echo "Uso: $0 NombreCasoDeUso (por ejemplo: $0 GetAssembledDayById)"
  exit 1
fi

# Nombre del caso de uso en PascalCase
USECASE_RAW="$1"

# Carpeta con el mismo nombre exacto
DIR_NAME="$USECASE_RAW"

USECASE_TS_PATH="$DIR_NAME/${USECASE_RAW}Usecase.ts"
TEST_TS_PATH="$DIR_NAME/__tests__/${USECASE_RAW}Usecase.test.ts"

# Evitar sobreescribir cosas por accidente
for path in "$USECASE_TS_PATH" "$TEST_TS_PATH"; do
  if [ -e "$path" ]; then
    echo "❌ Error: el archivo '$path' ya existe. Cancelo para no sobreescribir."
    exit 1
  fi
done

mkdir -p "$DIR_NAME/__tests__"

# ---- Template Usecase ----
cat > "$USECASE_TS_PATH" <<'EOF'
import { NotFoundError } from '@/domain/common/errors';

export type NAMEFROMSCRIPTUsecaseRequest = {
  xxxxId: string;
};

export class NAMEFROMSCRIPTUsecase {
  constructor(private xxxxRepo: XxxxRepo) {}

  async execute(
    request: NAMEFROMSCRIPTUsecaseRequest
  ): Promise<XxxxDTO | null> {
    const xxxx = await this.xxxxRepo.getXxxxById(request.xxxxId);
    if (!xxxx) {
      throw new NotFoundError(
        `NAMEFROMSCRIPTUsecase: Xxxx with id ${request.xxxxId} not found`
      );
    }

    // TODO IMPORTANT: Finish writing the usecase

    return toXxxxDTO(xxxx);
  }
}
EOF

# ---- Template Test ----
cat > "$TEST_TS_PATH" <<'EOF'
import { NotFoundError } from '@/domain/common/errors';
import { NAMEFROMSCRIPTUsecase } from '../NAMEFROMSCRIPTUsecase';
import { Xxxx } from '@/domain/xxxx/Xxxx';

import * as vp from '@/../tests/createProps';
import * as dto from '@/../tests/dtoProperties';

describe('NAMEFROMSCRIPTUsecase', () => {
  let xxxxRepo: MemoryXxxxRepo;
  let usecase: NAMEFROMSCRIPTUsecase;
  let xxxx: Xxxx; // TODO: inicializar con una entidad Xxxx válida

  beforeEach(async () => {
    xxxxRepo = new MemoryXxxxRepo();
    usecase = new NAMEFROMSCRIPTUsecase(xxxxRepo);

    // TODO: crear xxxx y guardarlo
    await xxxxRepo.saveXxxx(xxxx);
  });

  describe('Execution', () => {
    it('should return XxxxDTO', async () => {
      const result = await usecase.execute({
        xxxxId: xxxx.id,
        userId: vp.userId,
      });

      expect(result).not.toBeInstanceOf(Xxxx);
      for (const prop of dto.xxxxDTOProperties) {
        expect(result).toHaveProperty(prop);
      }
    });
  })

  //describe('Errors', () => {
  
  //})

});
EOF

# ---- Reemplazo del nombre ----
sed -i "s/NAMEFROMSCRIPT/$USECASE_RAW/g" "$USECASE_TS_PATH" "$TEST_TS_PATH"

echo "✅ Creado scaffolding de usecase:"
echo "  - $USECASE_TS_PATH"
echo "  - $TEST_TS_PATH"
