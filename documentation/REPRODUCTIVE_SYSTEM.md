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

## API Endpoints (pendientes)

```
POST   /api/lotes/:id/toros          - Asignar toro
DELETE /api/lotes/:id/toros/:toroId  - Desasignar toro
POST   /api/servicios                - Registrar servicio
POST   /api/partos                   - Registrar parto
POST   /api/destetes                 - Registrar destete
GET    /api/animales/:id/genealogia  - Árbol genealógico
PUT    /api/animales/:id/estado      - Cambiar estado reproductivo
```

---

## Migraciones SQL

1. `005_create_reproduction_system.sql` - Tablas base
2. `006_reproductive_categories.sql` - Categorías y settings
