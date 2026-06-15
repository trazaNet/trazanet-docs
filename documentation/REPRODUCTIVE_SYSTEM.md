# Sistema de Manejo Reproductivo - Documentación Técnica

## Descripción General

Este módulo permite gestionar el ciclo reproductivo del ganado, incluyendo:

- Categorías reproductivas (vaquillona, vaca lactación, etc.)
- Estados de preñez (vacía, cola, punta, parida)
- Tipos de manejo (IA, IATF, monta natural, etc.)
- Vinculación genealógica (madre-hijo, toro-lote)

---

## Base de Datos

### Tablas Principales

#### `animales` (columnas agregadas)

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `categoria_reproductiva` | VARCHAR(50) | Categoría actual del animal |
| `estado_prenez` | VARCHAR(30) | Estado de preñez para hembras |
| `ultimo_evento_reproductivo` | TIMESTAMP | Fecha del último cambio de estado |
| `madre_id` | UUID | Referencia a la madre |
| `padre_id` | UUID | Referencia al padre (o NULL si IA) |

#### `lotes` (columnas agregadas)

| Columna | Tipo | Descripción |
|---------|------|-------------|
| `tipo_manejo` | VARCHAR(30) | Tipo de manejo reproductivo |
| `categoria_lote` | VARCHAR(50) | Categoría predominante |

#### `lote_toros` (nueva)

Asignación de toros reproductores a lotes.

#### `servicios` (nueva)

Registro de inseminaciones y montas.

#### `partos` (nueva)

Registro de nacimientos con vinculación genealógica.

#### `destetes` (nueva)

Registro de destetes con peso.

#### `lote_vinculos` (nueva)

Vinculación de lotes de madres con lotes de crías.

#### `user_settings` (nueva)

Configuración de usuario (auto-detect toggle).

---

## Categorías Válidas

### `categoria_reproductiva` (animales)

- `vaquillona_1er_entore`
- `vaquillona_2do_entore`
- `vaca_lactacion`
- `vaca_fallada`
- `vaca_destetada_precoz`
- `sin_discriminar`
- `toro`
- `ternero`, `ternera`
- `novillo`, `torito`

### `estado_prenez` (animales)

- `vacia`
- `prenez_cola` (<4 meses)
- `prenez_punta` (>4 meses)
- `parida`
- `ciclando`
- `no_aplica` (machos)

### `tipo_manejo` (lotes)

- `dao` - Diagnóstico Actividad Ovárica
- `dt` - Destete Temporario
- `dp` - Destete Precoz
- `dao_dt`, `dao_dp`
- `ia` - Inseminación Artificial
- `iatf` - IA a Tiempo Fijo
- `monta_natural`
- `sin_manejo`

---

## Flutter - Archivos

### Servicios

- `lib/services/settings_service.dart` - Persistencia de configuración

### Pantallas

- `lib/screens/settings_screen.dart` - UI de configuración

### Widgets

- (pendiente) Árbol genealógico
- (pendiente) Selector de categoría

---

## API Endpoints (implementados)

Todas requieren header `Authorization: Bearer <token>` (Supabase auth) y responden con el
envelope estándar `{ success: boolean, data?, error?, message? }`. POST exitoso → `201`.

### Toros del lote
```
POST   /api/lotes/:id/toros          - Asignar toro al lote   body { toro_id, notas? }
GET    /api/lotes/:id/toros          - Listar toros activos del lote (join animales)
DELETE /api/lotes/:id/toros/:toroId  - Desasignar (soft: activo=false, fecha_retiro)
```

### Servicios (IA / monta / TE)
```
POST   /api/servicios                - Registrar servicio
GET    /api/servicios                - Listar  ?animal_id=&lote_id=&from=&to=
GET    /api/servicios/:id            - Obtener
PATCH  /api/servicios/:id            - Actualizar (ej. confirmar preñez)
DELETE /api/servicios/:id            - Eliminar
```
Body POST: `{ animal_id*, lote_id?, tipo* (inseminacion_artificial|monta_natural|transferencia_embrion), toro_id?, toro_externo_id?, toro_externo_nombre?, toro_externo_raza?, fecha_servicio*, inseminador?, cantidad_dosis?, notas? }`

### Partos
```
POST   /api/partos                   - Registrar parto
GET    /api/partos                   - Listar  ?madre_id=&from=&to=
GET    /api/partos/:id               - Obtener
PATCH  /api/partos/:id               - Actualizar
DELETE /api/partos/:id               - Eliminar
```
Body POST: `{ madre_id*, lote_id?, padre_id?, padre_externo_id?, servicio_id?, fecha_parto*, tipo_parto? (normal|distocico|cesarea|aborto|mortinato), cria_id?, cria_caravana?, cria_sexo?, cria_peso_nacimiento?, cantidad_crias?, notas? }`

### Destetes
```
POST   /api/destetes                 - Registrar destete
GET    /api/destetes                 - Listar  ?cria_id=&madre_id=
GET    /api/destetes/:id             - Obtener
DELETE /api/destetes/:id             - Eliminar
```
Body POST: `{ cria_id*, madre_id?, parto_id?, fecha_destete*, peso_destete?, edad_dias?, lote_destino_id?, notas? }`

### Genealogía y estado (animales)
```
GET    /api/animales/:id/genealogia?depth=3  - Árbol ascendente (usa RPC get_ancestors)
PUT    /api/animales/:id/estado              - Cambio manual de estado reproductivo
POST   /api/animales/:id/transicionar        - Transición auto por diagnóstico (ya existía)
```
`genealogia` devuelve `{ animal, ancestros: [{ id, caravana, sexo, nombre_raza, depth, role, path }] }`.
`estado` body: `{ categoria_reproductiva?, estado_prenez?, evento? }`; actualiza `animales` y
audita el cambio en `eventos_reproductivos` (tipo_evento `cambio_manual`).

---

## Tablas existentes (Supabase)

`servicios`, `partos`, `destetes`, `lote_toros`, `lote_vinculos`, `eventos_reproductivos`,
`user_settings`, más columnas reproductivas en `animales` y `lotes`.

## Migraciones SQL

1. `005_create_reproduction_system.sql` - Tablas base (servicios, partos, destetes, lote_toros, vista ranking)
2. `006_reproductive_categories.sql` - Categorías, lote_vinculos, user_settings, transiciones
3. `008_recursive_genealogy.sql` - Función `get_ancestors` (genealogía recursiva)
4. `043_auto_categoria_reproductiva.sql` - eventos_reproductivos, auto-detección y triggers
5. `049_fix_reproductive_fks.sql` - **Fix de FKs**: `servicios.created_by`, `partos.created_by`,
   `eventos_reproductivos.created_by` y `user_settings.user_id` estaban como `INTEGER REFERENCES
   public.users(id)` (tabla legacy). La app inserta el UUID de `auth.users`, así que todo insert
   fallaba (mismo patrón de bug que tuvo `perfiles`). Esta migración reapunta esas columnas a
   `auth.users(id)` (UUID) y recrea la vista `vw_historial_categorias` para joinear `perfiles`.
   ⚠️ Se aplica A MANO en Supabase SQL Editor (el repo API no tiene runner de migraciones).
