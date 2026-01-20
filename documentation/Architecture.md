# Arquitectura General de TrazaNet

Este documento detalla la estructura técnica y el flujo de datos del ecosistema TrazaNet.

## 🏗️ Diagrama de Componentes

```
                    ┌─────────────────────────────────────────┐
                    │            Campos / Cliente              │
                    │  ┌─────────────┐    ┌───────────────┐   │
                    │  │ Lector RFID │───▶│  App Móvil    │   │
                    │  │  Baqueano   │BLE │   Flutter     │   │
                    │  └─────────────┘    └───────┬───────┘   │
                    └─────────────────────────────┼───────────┘
                                                  │ HTTPS
                    ┌─────────────────────────────▼───────────┐
                    │              Nube - Cloud                │
                    │  ┌───────────────────────────────────┐  │
                    │  │      TrazaNet API (Node.js/TS)    │  │
                    │  │           Render.com              │  │
                    │  └───────────────┬───────────────────┘  │
                    │                  │ SQL                   │
                    │  ┌───────────────▼───────────────────┐  │
                    │  │    Supabase (PostgreSQL)          │  │
                    │  │    Auth + Storage + RLS           │  │
                    │  └───────────────────────────────────┘  │
                    └─────────────────────────────────────────┘
                    
                    ┌─────────────────────────────────────────┐
                    │         Futuro: APIs Externas            │
                    │    ┌─────────┐  ┌─────────┐             │
                    │    │  SNIG   │  │ DICOSE  │             │
                    │    └─────────┘  └─────────┘             │
                    └─────────────────────────────────────────┘
```

## 🔄 Flujo de Datos

```
┌──────────────┐    Bluetooth     ┌──────────────┐     HTTPS     ┌──────────────┐
│    Lector    │ ───────────────▶ │     App      │ ─────────────▶│   Backend    │
│   Baqueano   │       BLE        │    Mobile    │     JSON      │     API      │
└──────────────┘                  └──────┬───────┘               └──────┬───────┘
                                         │                              │
                                         │ Cache                        │ Query
                                         ▼                              ▼
                                  ┌──────────────┐               ┌──────────────┐
                                  │    Shared    │               │   Supabase   │
                                  │    Prefs     │◀─────────────▶│      DB      │
                                  └──────────────┘    Sync       └──────────────┘
```

1. **Captura de Datos**: El usuario escanea caravanas con el lector Baqueano.
2. **Transmisión Local**: BLE envía datos a la App Móvil.
3. **Cache Local**: SharedPreferences guarda lecturas para funcionar offline.
4. **Sincronización**: La App envía `POST /api/lecturas` con código, loteId y timestamp.
5. **Persistencia**: API registra en Supabase y detecta alertas.

## 📊 Modelo de Datos

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│    animales     │       │     lecturas    │       │      lotes      │
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ id (PK)         │◀──────│ animal_id (FK)  │       │ id (PK)         │
│ caravana        │       │ lote_id (FK)    │──────▶│ nombre          │
│ sexo            │       │ fecha           │       │ establecimiento │
│ fecha_nacimiento│       │ caravana        │       │ finalizado      │
└─────────────────┘       │ tipo            │       │ deleted_at      │
                          │ ubicacion       │       └─────────────────┘
                          │ datos           │
                          └─────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │   alertas_detectadas    │
                    ├─────────────────────────┤
                    │ animal_id (FK)          │
                    │ lote_esperado (FK)      │
                    │ lote_detectado (FK)     │
                    │ tipo                    │
                    │ resuelto                │
                    └─────────────────────────┘
```

Ver [DATA_MODEL_EVOLUTION.md](./database/DATA_MODEL_EVOLUTION.md) para detalles completos.

## 🔒 Seguridad

- **API**: Helmet + CORS estrictos
- **Base de Datos**: Supabase Service Role Key (solo en backend)
- **Comunicaciones**: HTTPS everywhere
- **RLS**: Row Level Security habilitado en Supabase

## 🌐 Servicios

| Servicio | Uso | URL |
|----------|-----|-----|
| **Supabase** | DB + Auth | Dashboard Supabase |
| **Render** | API Backend | `trazanet-api.onrender.com` |
| **GitHub** | Código | Repositorios privados |

---
*Arquitectura TrazaNet v2.0 - Enero 2026*
