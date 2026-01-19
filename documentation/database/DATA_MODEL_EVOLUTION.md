[Full content of previous file plus new section]

# Evolución del Modelo de Datos para Ciencia de Datos

Este documento describe las decisiones de arquitectura de datos tomadas para soportar futuros análisis de ciencia de datos, específicamente en el manejo de Lotes y Lecturas.

## Filosofía: Inmutabilidad e Historial

Para permitir análisis precisos (ej. ganancia de peso diaria, trazabilidad completa), adoptamos los siguientes principios:

1. **Animal = Entidad Única**: Un animal (caravana) es un registro único en la base de datos.
2. **Lectura = Evento Inmutable**: Cada interacción con un animal (pesaje, movimiento, tacto) genera una lectura que nunca se elimina.
3. **Lote = Agrupación Temporal**: Los lotes agrupan lecturas en un periodo de tiempo.

## Implementación de Soft Delete en Lotes

Para evitar la pérdida de datos históricos cuando un usuario "elimina" un lote de la interfaz, implementamos un mecanismo de **Soft Delete**.

### Esquema de Base de Datos

Se agregaron las siguientes columnas a la tabla `lotes`:

```sql
ALTER TABLE lotes ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE lotes ADD COLUMN archived BOOLEAN DEFAULT false;
```

* **`deleted_at`**: Timestamp de eliminación. Si es `NULL`, el lote está activo. Si tiene fecha, está eliminado para el usuario pero disponible para análisis.
* **`archived`**: Flag para lotes finalizados que se quieren ocultar de la vista principal sin eliminar.

### Comportamiento del API

* **GET `/api/lotes`**: Por defecto retorna solo lotes activos (`deleted_at IS NULL`).
  * Para análisis de datos, se puede usar `?includeDeleted=true` (a implementar si es necesario, o vía acceso directo a DB).
* **DELETE `/api/lotes/:id`**: No borra el registro físicamente. Simplemente actualiza `deleted_at = NOW()`.

### Ventajas para Ciencia de Datos

1. **Integridad Referencial**: Las lecturas históricas no quedan "huérfanas" de lote.
2. **Análisis de Tendencias**: Se pueden analizar datos de lotes antiguos eliminados por el usuario.
3. **Reversibilidad**: Si un usuario borra un lote por error, se puede restaurar (simplemente seteando `deleted_at = NULL`).

## Tabla `lecturas` y Data Science

Se agregó una columna `datos` de tipo JSONB a la tabla `lecturas` para flexibilizar la captura de variables sin alterar el esquema constantemente:

```sql
ALTER TABLE lecturas ADD COLUMN datos JSONB;
```

Esto permite guardar métricas variables como:

* Condition corporal
* Peso
* Observaciones veterinarias
* Preñez

## Diagrama Conceptual

Estructura de relaciones para análisis de datos:

```mermaid
graph LR
    ANIMAL[ANIMAL<br>(entidad única)] <-- (animal_id) --- LECTURA[LECTURA<br>(evento/observación)];
    LOTE[LOTE<br>(agrupación temporal)] <-- (lote_id) --- LECTURA;

    classDef default fill:#fff,stroke:#333,stroke-width:1px;
    class ANIMAL,LECTURA,LOTE default;
```

```text
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   ANIMAL    │     │   LECTURA    │     │    LOTE     │
│ (entidad    │◄────│ (evento/     │────►│ (agrupación │
│  única)     │     │  observación)│     │  temporal)  │
└─────────────┘     └──────────────┘     └─────────────┘
   ID único          timestamp           fecha_inicio
   caravana          animal_id           fecha_fin
   historial         lote_id             estado
                     tipo_lectura        deleted_at
                     datos_capturados    
  - `lectura` (evento/observación):
    - `id`: uuid (PK)
    - `fecha`: timestamp with time zone (NOT created_at, NOT fecha_hora)
    - `animal_id`: uuid (FK -> animales.id)
    - `lote_id`: uuid (FK -> lotes.id)
    - `tipo`: text ('manual', 'nfc', etc.)
    - `caravana`: text (snapshot at reading time)
    - `ubicacion`: jsonb (lat, lon)   
```

## Referencia de Esquema: Tabla `lotes`

Esquema actual de la tabla `lotes` en Supabase:

| Columna | Tipo | Default | Descripción |
| :--- | :--- | :--- | :--- |
| **id** | `uuid` | `gen_random_uuid()` | Identificador único del lote |
| **nombre** | `text` | `null` | Nombre legible del lote |
| **establecimiento** | `text` | `null` | Nombre del establecimiento (legacy) |
| **establecimiento_id** | `uuid` | `null` | FK a tabla establecimientos |
| **color** | `text` | `null` | Color identificador para UI |
| **fecha_creacion** | `timestamp` | `now()` | Fecha de creación del registro |
| **descripcion** | `text` | `null` | Notas adicionales |
| **tipo_trabajo** | `text` | `null` | Propósito (ej. sanitario, control) |
| **ubicacion** | `text` | `null` | Ubicación física (potrero) |
| **finalizado** | `boolean` | `false` | Si el trabajo en el lote concluyó |
| **fecha_finalizacion** | `timestamp` | `null` | Cuándo se finalizó |
| **deleted_at** | `timestamp` | `null` | [Soft Delete] Fecha de eliminación |
| **archived** | `boolean` | `false` | [Soft Delete] Si está archivado |

## Nueva Arquitectura: Lote (Estado) vs Lectura (Evento)

Para mejorar la UX y la claridad conceptual, distinguimos explícitamente entre **Inventario** e **Historial**.

### Concepto

* **Lote (Carpeta/Estado)**: Representa el inventario *actual*. "Lo que hay hoy".
  * Se visualiza en la pestaña **Inventario**.
  * Muestra lista de animales únicos presentes.
* **Lectura (Evento/Foto)**: Representa una acción puntual en el tiempo.
  * Se visualiza en la pestaña **Historial**.
  * Muestra *sesiones* o *logs de actividad*.
  * Ejemplos: "Sesión de lectura día X", "Agregado manual de animal Y".

### Estrategia de Agrupación (Historial)

Como no existe una tabla `sesiones`, el historial se construye virtualmente agrupando `lecturas`:

1. **Agrupación Temporal**: Lecturas realizadas en el mismo rango de tiempo (ej. +/- 1 hora) se consideran una "Sesión".
2. **Eventos Únicos**: Lecturas manuales o aisladas se muestran como eventos individuales.
