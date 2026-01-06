# 📚 Documentación TrazaNet

Esta carpeta contiene toda la documentación necesaria para entender y desarrollar el proyecto trazaNet.

## 🚀 Guías de Setup (¡Empezá aquí!)

| # | Guía | Descripción |
|---|------|-------------|
| 1 | [SETUP_EMAIL.md](./SETUP_EMAIL.md) | Configurar email corporativo |
| 2 | [SETUP_GITHUB.md](./SETUP_GITHUB.md) | Crear organización y repos en GitHub |
| 3 | [SETUP_SUPABASE.md](./SETUP_SUPABASE.md) | Configurar base de datos |
| 4 | [MIGRATION_MOBILE.md](./MIGRATION_MOBILE.md) | Migrar bt-test-app al nuevo repo |

## 📂 Estructura

```
documentation/
├── architecture/     # Arquitectura del sistema
│   ├── overview.md   # Diagramas y visión general
│   └── project_context.md  # Contexto empresarial
├── database/         # Esquemas de BD
│   └── schema.md     # Tablas y RLS
├── credentials/      # Gestión de secrets
├── mobile/           # Docs app Flutter
├── web/              # Docs frontend Angular
├── infrastructure/   # Docker, K8s (futuro)
├── legacy/           # Proyectos descartados
└── templates/        # Archivos base para nuevos repos
    ├── trazanet-mobile/
    ├── trazanet-api/
    ├── trazanet-web/
    └── trazanet-infra/
```

## 🏢 Contexto

| Campo | Valor |
|-------|-------|
| **Empresa** | +CríaUY |
| **Producto** | TrazaNet |
| **Stack** | Flutter + Angular + Node.js + Supabase |
| **Prioridad** | Mobile primero |

## 📋 Checklist Rápido

### ✅ Ya Tenés
- [x] Código mobile funcional (bt-test-app)
- [x] PWA base (trazaMovil) para web
- [x] Estructura de documentación
- [x] Templates para nuevos repos
- [x] Guías paso a paso

### 🔲 Próximos Pasos
- [ ] Comprar dominio trazanet.com
- [ ] Configurar email dev@trazanet.com
- [ ] Crear GitHub org
- [ ] Crear repos
- [ ] Migrar código

---

> ⚠️ La carpeta `credentials/` está en `.gitignore` - nunca subir credenciales al repo
