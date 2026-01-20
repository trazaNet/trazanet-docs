# 🏢 Contexto del Proyecto TrazaNet

## Empresa

| Campo | Valor |
|-------|-------|
| **Empresa madre** | +CríaUY |
| **Producto** | TrazaNet |
| **País target** | Uruguay |
| **Industria** | Trazabilidad ganadera |

## Visión General

TrazaNet es una plataforma de trazabilidad ganadera que conecta lectores de caravanas electrónicas con un sistema de gestión de datos. El objetivo es:

1. **Lectura de caravanas** via Bluetooth desde lectores RFID (Baqueano)
2. **Organización de datos** de animales, lotes, movimientos y alertas
3. **Generación de guías** para trámites oficiales (SNIG, DICOSE)
4. **Detección de alertas** en tiempo real (animal faltante, cambio de lote)

## Productos

| Nombre | Tipo | Tech Stack | Estado | Ubicación |
|--------|------|------------|--------|-----------|
| **trazaNet Mobile** | App iOS/Android | Flutter | ✅ Funcional | `trazanet-mobile-new/` |
| **trazaNet API** | Backend | Node.js/TypeScript | ✅ Funcional | `trazanet-api-new/` |
| **trazaNet Web** | Web App | Angular 17 | 📋 Planificado | - |

## Infraestructura Actual

| Servicio | Proveedor | Estado |
|----------|-----------|--------|
| Base de datos | Supabase (PostgreSQL) | ✅ Producción |
| API Backend | Render | ✅ Deployado |
| App Mobile | Local/TestFlight | ✅ En testing |

## Usuarios Target

| Rol | Descripción | Features |
|-----|-------------|----------|
| **Productor** | Dueño/encargado de establecimiento | Registro de animales, lotes, estadísticas básicas |
| **Veterinario** | Profesional certificador | Trabajos veterinarios, certificaciones oficiales (futuro) |

## Decisiones Técnicas

### ¿Por qué Flutter para Mobile?

- PWA descartada por limitaciones de Bluetooth en iOS
- Flutter permite generar .apk y .ipa desde mismo código
- Conexión BLE exitosa con lectores Baqueano

### ¿Por qué Supabase?

- Requisito del cliente
- PostgreSQL con API REST automática
- Auth, Storage, Realtime incluidos
- RLS para seguridad a nivel de fila

### ¿Por qué Node.js para API?

- Mayor control sobre lógica de negocio compleja
- Integración futura con APIs externas (SNIG, DICOSE)
- TypeScript para type safety
- Express + Swagger para documentación automática

## Arquitectura Target

```
┌─────────────────┐     ┌─────────────────┐
│  trazaNet App   │     │  trazaNet Web   │
│    (Flutter)    │     │   (Angular)     │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │ trazaNet API│
              │  (Node.js)  │
              └──────┬──────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
    ┌────▼────┐ ┌────▼────┐ ┌────▼────┐
    │Supabase │ │  SNIG   │ │ DICOSE  │
    │   DB    │ │   API   │ │   API   │
    └─────────┘ └─────────┘ └─────────┘
```

## Prioridades de Desarrollo

1. ✅ **Mobile** - App de lectura funcional
2. ✅ **Backend API** - Lógica de negocio y persistencia
3. 🔄 **Alertas persistentes** - Usando tabla `alertas_detectadas`
4. 📋 **Web Dashboard** - Gestión desde escritorio
5. 📋 **Flujo Veterinario** - Certificaciones oficiales

## Hardware Compatible

- **Lectores BT**: Baqueano (protocolo propietario via BLE)
- **Caravanas RFID**: Estándar Uruguay (ISO 11784/11785)
