# 📚 Documentación TrazaNet

Esta carpeta contiene toda la documentación del proyecto TrazaNet.

## 🚀 Estado Actual

| Componente | Estado | Ubicación |
|------------|--------|-----------|
| App Mobile (Flutter) | ✅ Funcional | `trazanet-mobile-new/` |
| API Backend (Node.js) | ✅ Deployado en Render | `trazanet-api-new/` |
| Base de Datos | ✅ Supabase Producción | PostgreSQL |
| Web Dashboard | 📋 Planificado | - |

## 📂 Estructura de Documentación

```
documentation/
├── architecture/          # Arquitectura del sistema
│   ├── overview.md        # Diagramas y visión general
│   └── project_context.md # Contexto empresarial
├── database/              # Modelo de datos
│   └── DATA_MODEL_EVOLUTION.md  # Schema y roadmap
├── api/                   # Documentación API
├── mobile/                # Docs app Flutter
├── credentials/           # Gestión de secrets (NO subir)
└── legacy/                # Proyectos descartados
```

## 🏢 Contexto

| Campo | Valor |
|-------|-------|
| **Empresa** | +CríaUY |
| **Producto** | TrazaNet |
| **Stack** | Flutter + Node.js + Supabase |
| **Deploy** | Render (API) + Supabase (DB) |

## 📋 Features Implementadas

- [x] Lectura RFID via Bluetooth (Baqueano)
- [x] CRUD de Lotes y Animales
- [x] Agrupación de lecturas en "Guías"
- [x] Detección de alertas (cambio_lote, animal_faltante)
- [x] Persistencia de alertas en `alertas_detectadas`
- [x] Entrada manual de caravanas
- [x] Cache local de lecturas

## 🔲 Próximos Pasos

- [ ] Flujo veterinario (trabajos, certificaciones)
- [ ] Multi-establecimiento
- [ ] Export SNIG
- [ ] Web Dashboard
- [ ] Histórico de peso

---

> ⚠️ La carpeta `credentials/` está en `.gitignore` - nunca subir credenciales al repo
