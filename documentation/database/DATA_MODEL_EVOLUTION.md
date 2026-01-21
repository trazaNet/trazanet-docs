# Arquitectura de Datos TrazaNet

## Visión General

TrazaNet soporta dos flujos de usuario:

- **Productor**: Registro y estadísticas de animales (MVP actual)
- **Veterinario**: Certificación oficial de lotes (futuro)

---

## Concepto Clave: Lote vs Guía

> **Esta distinción es fundamental para entender el modelo de datos.**

| Concepto | Definición | Analogía |
|----------|------------|----------|
| **Lote** | Contenedor de trabajo | Carpeta de expediente |
| **Guía** | Sesión de lectura con propósito | Página del expediente |

### ¿Por qué importa?

- **Lote**: Agrupador estático → "Lote Potrero Norte", "Vacas 2026"
- **Guía**: Sesión dinámica → "Recuento de preñez 20/01", "Vacunación aftosa"
- El `tipo_trabajo` **debería** estar en la Guía, no en el Lote

### Estado Actual vs Futuro

```
ACTUAL:                          FUTURO:
┌─────────────┐                  ┌─────────────┐
│    Lote     │                  │    Lote     │
│ tipo_trabajo│ ◀── aquí está    │ (solo meta) │
└──────┬──────┘                  └──────┬──────┘
       │                                │
       ▼                                ▼
┌─────────────┐                  ┌─────────────┐
│  Lecturas   │                  │   Guías     │ ◀── tabla nueva
│ (sin tipo)  │                  │ tipo_trabajo│
└─────────────┘                  └──────┬──────┘
                                        │
                                        ▼
                                 ┌─────────────┐
                                 │  Lecturas   │
                                 └─────────────┘
```

### Migración Pendiente

1. Crear tabla `guias` con `tipo_trabajo`, `fecha_inicio`, `fecha_fin`
2. Vincular `lecturas.guia_id` → `guias.id`
3. Actualizar wizard para crear guía por sesión

---

## Diagrama Entidad-Relación

```
┌────────────────────────────────────────────────────────────────────────────┐
│                              USUARIOS                                      │
│  ┌────────────┐                                                            │
│  │  perfiles  │                                                            │
│  └─────┬──────┘                                                            │
│        │ crea                                                              │
│        ▼                                                                   │
│  ┌──────────────────┐          ┌──────────────────────┐                    │
│  │ establecimientos │          │ trabajos_veterinarios│◀──┐                │
│  └────────┬─────────┘          └───────────┬──────────┘    │               │
│           │ contiene                       │ genera        │ realiza       │
│           ▼                                ▼               │               │
│     ┌──────────┐                   ┌───────────────┐       │               │
│     │  lotes   │                   │certificaciones│───────┘               │
│     └────┬─────┘                   └───────────────┘                       │
│          │                                                                 │
└──────────┼─────────────────────────────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                           CORE - LECTURAS                                  │
│                                                                            │
│  ┌──────────┐         ┌──────────────┐         ┌────────────────────┐    │
│  │  lotes   │◀────────│   lecturas   │────────▶│     animales       │    │
│  └────┬─────┘         └──────┬───────┘         └─────────┬──────────┘    │
│       │                      │                           │               │
│       │                      ▼                           │               │
│       │         ┌─────────────────────────┐              │               │
│       └────────▶│   alertas_detectadas    │◀─────────────┘               │
│                 │  - lote_esperado (FK)   │                              │
│                 │  - lote_detectado (FK)  │                              │
│                 │  - animal_id (FK)       │                              │
│                 └─────────────────────────┘                              │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                        EXTENSIONES (FUTURO)                               │
│                                                                           │
│  ┌────────────────┐  ┌────────────────┐  ┌─────────────────┐             │
│  │ peso_animales  │  │ movimientos    │  │ manejos_aplicados│            │
│  └────────────────┘  └────────────────┘  └─────────────────┘             │
│                                                                           │
│  ┌────────────────┐  ┌────────────────┐  ┌─────────────────┐             │
│  │  diagnosticos  │  │ ubicaciones    │  │   etiquetas     │             │
│  └────────────────┘  └────────────────┘  └─────────────────┘             │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Estado de Uso por Tabla

| Tabla | Estado | Flujo | Descripción |
|-------|--------|-------|-------------|
| `animales` | ✅ Activa | Ambos | Entidad central |
| `lotes` | ✅ Activa | Ambos | Agrupación de trabajo |
| `lecturas` | ✅ Activa | Ambos | Eventos de lectura RFID |
| `alertas_detectadas` | ✅ Activa | Productor | Alertas persistidas |
| `perfiles` | 🔜 Próximo | Ambos | Auth y roles de usuario |
| `establecimientos` | 🔜 Próximo | Ambos | Multi-estancia |
| `trabajos_veterinarios` | 📅 Futuro | Veterinario | Sesiones de certificación |
| `certificaciones` | 📅 Futuro | Veterinario | Documentos oficiales |
| `movimientos_animales` | 📅 Futuro | Ambos | Trazabilidad entre lotes |
| `diagnosticos` | 📅 Futuro | Veterinario | Diagnósticos clínicos |
| `manejos_aplicados` | 📅 Futuro | Ambos | Tratamientos y acciones |
| `peso_animales` | 📅 Futuro | Ambos | Histórico de pesajes |
| `etiquetas*` | 📅 Futuro | Ambos | Sistema de etiquetado |
| `ubicaciones_animales` | 📅 Futuro | Ambos | GPS tracking |

---

## Flujo Productor (MVP Actual)

```
  PRODUCTOR                    APP                         API                    DB
      │                         │                           │                      │
      │ Crea Lote               │                           │                      │
      ├────────────────────────▶│                           │                      │
      │                         │ POST /lotes               │                      │
      │                         ├──────────────────────────▶│                      │
      │                         │                           │ INSERT lotes         │
      │                         │                           ├─────────────────────▶│
      │                         │                           │                      │
      │ Escanea caravana        │                           │                      │
      ├────────────────────────▶│                           │                      │
      │                         │ POST /lecturas            │                      │
      │                         ├──────────────────────────▶│                      │
      │                         │                           │ INSERT animales      │
      │                         │                           │ (si no existe)       │
      │                         │                           ├─────────────────────▶│
      │                         │                           │ INSERT lecturas      │
      │                         │                           ├─────────────────────▶│
      │                         │                           │                      │
      │                         │                           │ ¿Cambio de lote?     │
      │                         │                           │ INSERT alertas       │
      │                         │                           ├─────────────────────▶│
      │                         │                           │                      │
      │ Ver Guías               │                           │                      │
      ├────────────────────────▶│ GET /lotes/:id/guias      │                      │
      │                         ├──────────────────────────▶│                      │
      │                         │                           │ SELECT lecturas      │
      │                         │                           │ GROUP BY fecha       │
      │                         │◀──────────────────────────│◀─────────────────────│
      │◀────────────────────────│                           │                      │
      │                         │                           │                      │
```

---

## Schema de Tablas Principales

### `lecturas`

| Columna | Tipo | Nullable | Descripción |
|---------|------|----------|-------------|
| id | uuid | ❌ | PK auto-generado |
| animal_id | uuid | ✅ | FK → animales |
| lector_id | uuid | ✅ | Dispositivo físico (no usado) |
| trabajo_id | uuid | ✅ | FK → trabajos_veterinarios (futuro) |
| lote_id | uuid | ✅ | FK → lotes |
| fecha | timestamp | ✅ | Momento de la lectura |
| ubicacion | jsonb | ✅ | {lat, lon} GPS |
| caravana | text | ✅ | Snapshot del código |
| tipo | text | ✅ | 'manual', 'nfc', etc. |
| datos | json | ✅ | Notas, condición corporal, etc. |

### `alertas_detectadas`

| Columna | Tipo | Nullable | Descripción |
|---------|------|----------|-------------|
| id | uuid | ❌ | PK |
| animal_id | uuid | ✅ | FK → animales |
| lote_esperado | uuid | ✅ | Donde debería estar |
| lote_detectado | uuid | ✅ | Donde apareció |
| tipo | text | ✅ | 'faltante', 'cambio_lote' |
| motivo | text | ✅ | Descripción legible |
| fecha | timestamp | ✅ | Cuándo se detectó |
| resuelto | bool | ✅ | Si ya se atendió |
| resuelto_por | text | ✅ | Quién lo resolvió |
| fecha_resuelto | timestamp | ✅ | Cuándo |
| comentario | text | ✅ | Notas adicionales |

---

## Roadmap de Features

### Fase 1: Productor MVP ✅

- [x] CRUD Lotes
- [x] Lectura RFID
- [x] Agregar manual
- [x] Inventario (animales únicos)
- [x] Guías (sesiones agrupadas)
- [x] Alertas persistentes

### Fase 2: Multi-Establecimiento 🔜

- [ ] Integrar tabla `establecimientos`
- [ ] Vincular `perfiles` con auth de Supabase
- [ ] Lotes por establecimiento

### Fase 3: Flujo Veterinario 📅

- [ ] Rol veterinario en `perfiles`
- [ ] Crear `trabajos_veterinarios`
- [ ] Vincular lecturas a trabajo
- [ ] Emitir `certificaciones`

### Fase 4: Analytics 📅

- [ ] Histórico de peso (`peso_animales`)
- [ ] Tracking GPS (`ubicaciones_animales`)
- [ ] Movimientos entre lotes (`movimientos_animales`)
- [ ] Dashboards de estadísticas
