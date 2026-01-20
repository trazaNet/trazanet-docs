# 📋 Checklist de Setup - TrazaNet

> **Última actualización**: Enero 2026

Usá este checklist para trackear tu progreso.

## Fase 1: Identidad Digital ✅

- [x] **Dominio**
  - [x] Registrar dominio
  - [x] Verificar que funciona

- [x] **Servicios Cloud**
  - [x] Cuenta Supabase
  - [x] Cuenta Render
  - [x] Cuenta GitHub

## Fase 2: GitHub ✅

- [x] **Organización**
  - [x] Repositorios creados
  - [x] SSH keys configuradas

- [x] **Repositorios Activos**
  - [x] `trazanet-mobile-new` (Flutter)
  - [x] `trazanet-api-new` (Node.js/TypeScript)
  - [x] `trazanet-docs-repo` (Documentación)

## Fase 3: Supabase ✅

- [x] **Proyecto**
  - [x] Proyecto creado en Supabase
  - [x] Database Password guardado
  - [x] URL y keys configuradas

- [x] **Base de Datos**
  - [x] Tablas principales creadas
  - [x] RLS policies configuradas
  - [x] Foreign keys establecidas

## Fase 4: Desarrollo ✅

- [x] **Mobile App**
  - [x] Conexión Bluetooth con Baqueano
  - [x] Lectura de caravanas RFID
  - [x] CRUD de lotes
  - [x] Agregar animales manual
  - [x] Cache local de lecturas
  - [x] Pantalla de "Guías"
  - [x] Detección de alertas en tiempo real

- [x] **API Backend**
  - [x] Express + TypeScript
  - [x] Swagger documentación
  - [x] Endpoints de lecturas
  - [x] Endpoints de lotes
  - [x] Endpoints de alertas
  - [x] Deployado en Render

## Fase 5: En Progreso 🔄

- [ ] **Alertas Persistentes**
  - [x] Tabla `alertas_detectadas` en DB
  - [x] POST `/api/alertas` crea alertas
  - [x] GET `/api/lotes/:id/alertas` lee de tabla
  - [ ] UI para resolver alertas

- [ ] **Flujo Veterinario**
  - [ ] Tabla `trabajos_veterinarios` integrada
  - [ ] Tabla `certificaciones` integrada
  - [ ] UI de formularios

## Fase 6: Futuro 📋

- [ ] **Multi-Establecimiento**
  - [ ] Integrar tabla `establecimientos`
  - [ ] Selector de establecimiento en UI

- [ ] **Export SNIG**
  - [ ] Formato de exportación definido
  - [ ] Endpoint de generación

- [ ] **Web Dashboard**
  - [ ] Angular app
  - [ ] Visualización de datos
  - [ ] Reportes

---

## Notas

| Hito | Fecha |
|------|-------|
| Mobile MVP | ✅ Completado |
| API MVP | ✅ Completado |
| Alertas persistentes | 🔄 En progreso |
