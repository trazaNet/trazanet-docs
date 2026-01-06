# 🏢 Contexto del Proyecto TrazaNet

## Empresa

| Campo | Valor |
|-------|-------|
| **Empresa madre** | +CríaUY |
| **Producto** | trazaNet |
| **País target** | Uruguay |
| **Industria** | Trazabilidad ganadera |

## Visión General

TrazaNet es una plataforma de trazabilidad ganadera que conecta lectores de caravanas electrónicas con un sistema de gestión de datos. El objetivo es:

1. **Lectura de caravanas** via Bluetooth desde lectores RFID
2. **Organización de datos** de animales, lotes, movimientos
3. **Generación de planillas** para trámites oficiales (DICOSE, SNIG, etc.)

## Productos

| Nombre | Tipo | Tech Stack | Estado |
|--------|------|------------|--------|
| **trazaNet Mobile** | App iOS/Android | Flutter | ✅ Funcional (ex bt-test-app) |
| **trazaNet Web** | Web App | Angular 17 | 🔄 En desarrollo |
| **trazaNet API** | Backend | Por definir | 📋 Planificado |

## Proyectos Legado (Descartados)

| Nombre | Razón de descarte | Valor rescatable |
|--------|-------------------|------------------|
| trazaMovil (PWA) | iOS no permite BT en PWAs | UI/UX, lógica de negocio |
| GeoMu | No funcional | Diseños de interfaz, mapa |

## Decisiones Técnicas

### ¿Por qué Flutter para Mobile?
- PWA descartada por limitaciones de Bluetooth en iOS
- Flutter permite generar .apk y .ipa desde mismo código
- bt-test-app ya probada exitosamente en iPhone y Android

### ¿Por qué Supabase?
- Requisito del cliente
- PostgreSQL con API REST automática
- Auth, Storage, Realtime incluidos
- Edge Functions para lógica serverless

### ¿Por qué Backend propio además de Supabase?
- Mayor control sobre lógica de negocio compleja
- Integración con APIs externas (SNIG, DICOSE)
- Generación de reportes/planillas
- Posibilidad de migrar de Supabase si es necesario

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
              │ trazaNet API │
              │  (Backend)   │
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

1. **Mobile primero** - La app de lectura es el core del negocio
2. **Backend API** - Para lógica de negocio y generación de planillas
3. **Web** - Dashboard de gestión y reportes

## Hardware Compatible

- **Lectores BT**: Investigar modelos compatibles (docs en `mobile/bluetooth.md`)
- **Caravanas RFID**: Estándar Uruguay (ISO 11784/11785)
