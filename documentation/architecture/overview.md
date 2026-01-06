# 🏗️ Arquitectura General - TrazaNet

## Diagrama de Arquitectura

```
                           ┌─────────────────────────────────────────┐
                           │              +CríaUY                     │
                           │         (Empresa Madre)                  │
                           └─────────────────────────────────────────┘
                                              │
                           ┌──────────────────▼──────────────────┐
                           │           TrazaNet                   │
                           │     (Plataforma de Trazabilidad)     │
                           └──────────────────┬──────────────────┘
                                              │
          ┌───────────────────────────────────┼───────────────────────────────────┐
          │                                   │                                   │
          ▼                                   ▼                                   ▼
┌─────────────────┐               ┌─────────────────┐               ┌─────────────────┐
│  TrazaNet App   │               │  TrazaNet API   │               │  TrazaNet Web   │
│    (Mobile)     │               │   (Backend)     │               │   (Frontend)    │
│                 │               │                 │               │                 │
│  ┌───────────┐  │               │  ┌───────────┐  │               │  ┌───────────┐  │
│  │  Flutter  │  │               │  │  Node.js  │  │               │  │ Angular 17│  │
│  │  BT/BLE   │  │               │  │    or     │  │               │  │ Tailwind  │  │
│  │  iOS/And  │  │               │  │  Python   │  │               │  │Container  │  │
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
│  RFID    │                  │  Mobile  │              │   API    │
└──────────┘                  └──────────┘              └────┬─────┘
                                   │                        │
                                   │ Offline                │
                                   │ Storage                │
                                   ▼                        ▼
                              ┌──────────┐            ┌──────────┐
                              │  SQLite  │            │ Supabase │
                              │  Local   │ ─────────► │    DB    │
                              └──────────┘   Sync     └──────────┘
```

## Componentes por Repositorio

### `trazanet-mobile` (Flutter)
- Conexión Bluetooth con lectores
- Lectura y parseo de caravanas
- Storage local (SQLite)
- Sincronización offline-first
- Auth via Supabase

### `trazanet-api` (Node.js/Python)
- REST API para web
- Lógica de negocio compleja
- Generación de planillas/reportes
- Integración con SNIG/DICOSE (futuro)
- Validaciones y reglas de negocio

### `trazanet-web` (Angular)
- Dashboard de gestión
- Visualización de datos
- Reportes y estadísticas
- Admin panel
- Gestión de usuarios

### `trazanet-infra`
- Docker Compose local
- Kubernetes manifests
- GitHub Actions CI/CD
- Terraform (futuro)

## Servicios Cloud

| Servicio | Uso | Tier |
|----------|-----|------|
| Supabase | DB, Auth, Storage | Free → Pro |
| Vercel | Deploy web | Free → Pro |
| GitHub | Código, CI/CD | Free |
| Railway/Render | Deploy API | Free → Pro |

## Seguridad

- Auth centralizada en Supabase
- JWT tokens para API
- RLS (Row Level Security) en DB
- HTTPS everywhere
- Secrets en variables de entorno
