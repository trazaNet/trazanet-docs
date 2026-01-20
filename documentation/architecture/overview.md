# 🏗️ Arquitectura General - TrazaNet

## Diagrama de Arquitectura

```
                           ┌─────────────────────────────────────────┐
                           │              +CríaUY                    │
                           │         (Empresa Madre)                 │
                           └─────────────────────────────────────────┘
                                              │
                           ┌──────────────────▼──────────────────┐
                           │           TrazaNet                  │
                           │     (Plataforma de Trazabilidad)    │
                           └──────────────────┬──────────────────┘
                                              │
          ┌───────────────────────────────────┼───────────────────────────────────┐
          │                                   │                                   │
          ▼                                   ▼                                   ▼
┌─────────────────┐               ┌─────────────────┐               ┌─────────────────┐
│  TrazaNet App   │               │  TrazaNet API   │               │  TrazaNet Web   │
│    (Mobile)     │               │   (Backend)     │               │   (Dashboard)   │
│                 │               │                 │               │                 │
│  ┌───────────┐  │               │  ┌───────────┐  │               │  ┌───────────┐  │
│  │  Flutter  │  │               │  │  Node.js  │  │               │  │ Angular 17│  │
│  │  BT/BLE   │  │               │  │TypeScript │  │               │  │ Tailwind  │  │
│  │  iOS/And  │  │               │  │  Express  │  │               │  │ (Futuro)  │  │
│  └───────────┘  │               │  └───────────┘  │               │  └───────────┘  │
└────────┬────────┘               └────────┬────────┘               └────────┬────────┘
         │                                 │                                 │
         │                                 │                                 │
         └────────────────┬────────────────┴────────────────┬────────────────┘
                          │                                 │
                          ▼                                 ▼
               ┌─────────────────┐               ┌─────────────────┐
               │    Supabase     │               │  APIs Externas  │
               │                 │               │                 │
               │  ┌───────────┐  │               │  ┌───────────┐  │
               │  │PostgreSQL │  │               │  │   SNIG    │  │
               │  │   Auth    │  │               │  │  DICOSE   │  │
               │  │  Storage  │  │               │  │  (Futuro) │  │
               │  └───────────┘  │               │  └───────────┘  │
               └─────────────────┘               └─────────────────┘
```

## Flujo de Datos Principal

```
┌──────────┐    Bluetooth     ┌──────────┐     API      ┌──────────┐
│  Lector  │ ───────────────► │   App    │ ───────────► │ Backend  │
│Baqueano  │       BLE        │  Mobile  │    HTTPS     │   API    │
└──────────┘                  └──────────┘              └───┬──────┘
                                   │                        │
                                   │ Cache                  │
                                   │ Local                  │
                                   ▼                        ▼
                              ┌──────────┐            ┌──────────┐
                              │  Shared  │            │ Supabase │
                              │  Prefs   │ ─────────► │    DB    │
                              └──────────┘   Sync     └──────────┘
```

## Componentes por Repositorio

### `trazanet-mobile-new` (Flutter) ✅

- Conexión Bluetooth BLE con lectores Baqueano
- Lectura y parseo de caravanas RFID
- Storage local (SharedPreferences)
- Cache de lecturas offline
- Detección de alertas en tiempo real
- UI con tabs: Resumen, Inventario, Guías, Alertas

### `trazanet-api-new` (Node.js/TypeScript) ✅

- REST API con Express
- Swagger para documentación
- Endpoints: `/lecturas`, `/lotes`, `/animales`, `/alertas`
- Persistencia de alertas en `alertas_detectadas`
- Integración con Supabase Admin

### `trazanet-web` (Angular) 📋 Planificado

- Dashboard de gestión
- Visualización de datos
- Reportes y estadísticas
- Admin panel

## Servicios Cloud

| Servicio | Uso | Estado |
|----------|-----|--------|
| Supabase | DB, Auth, Storage | ✅ Producción |
| Render | Deploy API | ✅ Producción |
| GitHub | Código, CI/CD | ✅ Activo |

## Seguridad

- Auth centralizada en Supabase
- JWT tokens para API
- RLS (Row Level Security) en DB
- HTTPS everywhere
- Secrets en variables de entorno
- CORS configurado en API
