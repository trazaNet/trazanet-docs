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
