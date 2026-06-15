# Módulo de Inversiones

> Estado: documentación inicial. Las secciones marcadas con `TODO` deben completarse
> verificando el código fuente (no se documentan detalles sin confirmar).

## Descripción General

Módulo para registrar y seguir inversiones asociadas a la operación ganadera
(compra de animales, insumos, infraestructura, etc.) y su retorno.

## Base de Datos

- Existe una tabla de inversiones (en la app legacy: `apps antiguas/web app/web/backend/src/migrations/001_create_inversiones_table.sql`).
- TODO: confirmar si la versión vigente vive en Supabase (`trazanet-api-new`) o solo en la app legacy, y listar las columnas reales.

## API

- TODO: confirmar endpoints de inversiones en `trazanet-api-new/src/routes/` (al momento de escribir esto no hay un `inversiones.ts` en la API nueva).

## UI

- TODO: documentar dónde se gestiona inversiones (web Angular 19 `trazanet-web-new` y/o mobile Flutter `trazanet-mobile-new`).

## Pendiente

Este documento es un esqueleto. Completar con: esquema de tablas, endpoints, reglas de negocio
(cálculo de retorno/ROI si aplica) y capturas/flujos de UI, todo verificado contra el código.
