# Estrategia de Sincronización (Offline-First)

TrazaNet utiliza un enfoque **Offline-First** robusto para garantizar que la operación en el campo nunca se interrumpa por falta de conectividad. Este documento detalla la arquitectura de sincronización.

## Arquitectura

La sincronización se maneja principalmente a través de tres componentes:

1. **LocalStorage (SQLite)**: Fuente de verdad inmediata para la UI.
2. **ApiService**: Capa de abstracción que decide si leer/escribir en local o red.
3. **SyncService**: Cola de tareas en segundo plano para reintentar operaciones fallidas.

## Flujo de Lectura (Read)

1. La UI solicita datos (ej. `ApiService.obtenerAnimales()`).
2. El servicio consulta **primero** la base de datos local SQLite.
3. Si hay conexión a internet:
    * Se realiza un request a la API en segundo plano.
    * Si el request es exitoso (200 OK), se actualiza la base de datos local con los nuevos datos (`saveAnimalesGlobal`).
    * (Opcional) La UI se actualiza reactivamente si está escuchando cambios, o en la próxima carga.
4. Si no hay conexión, se retornan los datos locales silenciando el error de red.

## Flujo de Escritura (Write)

### Creación (ej. Nuevo Lote)

1. Se genera un UUID temporal o definitivo en el cliente.
2. Se guarda el registro en SQLite inmediatamente con un flag `synced = 0`.
3. **Intento Inmediato**: Se intenta enviar POST a la API.
    * **Éxito**: Se marca `synced = 1` en SQLite y se actualiza el ID si el servidor asignó uno nuevo.
    * **Fallo (Offline)**: El registro queda con `synced = 0`. El `SyncService` lo detectará luego.

### Modificación/Acción (ej. Finalizar Guía)

1. Se aplica el cambio localmente.
2. Si falla el request online, la operación se encola en `pending_operations` (tabla local).
3. Registro: `parametro_cuerpo`, `endpoint`, `metodo`.

## SyncService (Cola de Reintentos)

El `SyncService` se ejecuta:

* Al iniciar la app.
* Cuando se detecta recuperación de conexión (`ConnectivityPlus`).
* Periódicamente cada X minutos (configurable).

**Lógica de Proceso**:

1. Busca registros en tablas locales con `synced = 0`.
2. Busca operaciones en `pending_operations`.
3. Ejecuta los requests cronológicamente.
4. Si un request falla con error 4xx (cliente), se marca como error fatal y no se reintenta (requiere intervención).
5. Si falla con 5xx o timeout, se mantiene en cola.

## Conflictos

Actualmente se utiliza una estrategia **"Last Write Wins"** (última escritura gana) basada en el servidor para colisiones simples. Para entidades complejas (como inventario de lotes), el servidor es la fuente de verdad y sobrescribe el estado local al volver a conectar.
