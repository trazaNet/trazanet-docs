# Referencia de API (TrazaNet)

Base URL: `https://trazanet-api.onrender.com/api`

## Autenticación

(Pendiente de implementación final - Actualmente Open/Dev)
Headers requeridos: `Content-Type: application/json`

## Endpoints Principales

### 🐄 Animales

* `GET /animales`: Listar todos los animales (paginado).
* `GET /animales/:caravana`: Detalle completo de un animal.
* `POST /animales`: Registrar nuevo animal (automático al crear lectura si no existe).
* `PATCH /animales/:caravana/baja`: Dar de baja (soft delete).

### 📦 Lotes

* `GET /lotes`: Listar lotes activos.
* `POST /lotes`: Crear nuevo lote.
  * Body: `{ nombre, predio_id, establecimiento_id, ... }`
* `GET /lotes/:id/animales`: Inventario de animales en el lote.
* `GET /lotes/:id/alertas`: Alertas activas asociadas al lote.

### 📍 Predios

* `GET /predios`: Listar predios por establecimiento.
* `POST /predios`: Crear predio.
  * Body: `{ nombre, establecimiento_id, superficie_ha }`

### 📱 Lecturas (Core)

* `POST /lecturas`: Registrar evento de lectura (RFID/Manual).
  * Body: `{ caravana, lote_id, ubicacion: {lat, lon}, datos: {...} }`
* `POST /lecturas/finalizar-sesion`: Cierre de trabajo con comparativa de inventario.

### 🚨 Alertas

* `GET /alertas`: Listar alertas globales.
* `PATCH /alertas/:id/resolver`: Marcar alerta como resuelta.
  * Body: `{ comentario, resuelto_por }`

## Estructuras Comunes

### Respuesta Estándar

```json
{
  "success": true,
  "data": { ... },
  "message": "Operación existosa"
}
```

### Respuesta de Error

```json
{
  "success": false,
  "error": "Descripción del error",
  "code": "ERROR_CODE"
}
```
