# 🔐 Gestión de Credenciales

> ⚠️ **IMPORTANTE**: Esta carpeta NO debe subirse a Git. Agregar a `.gitignore`.

## Estructura

```
credentials/
├── README.md            # Este archivo (sí va a git)
├── .env.example         # Template de variables (sí va a git)
├── .env.development     # Credenciales dev (NO va a git)
├── .env.staging         # Credenciales staging (NO va a git)
├── .env.production      # Credenciales prod (NO va a git)
└── service-accounts/    # Claves de servicio (NO va a git)
```

## Variables de Entorno

### Supabase
```env
SUPABASE_URL=https://TU_PROYECTO.supabase.co
SUPABASE_ANON_KEY=TU_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=TU_SERVICE_ROLE_KEY  # Solo backend
```

### Base de Datos (conexión directa)
```env
DATABASE_URL=postgresql://user:pass@host:5432/db
```

### APIs Externas
```env
SNIG_API_KEY=xxx
DICOSE_API_KEY=xxx
```

## Cuentas y Servicios

| Servicio | Email de cuenta | Propósito |
|----------|-----------------|-----------|
| GitHub | pendiente | Código fuente |
| Supabase | pendiente | Base de datos |
| Vercel | pendiente | Deploy web |
| Play Store | pendiente | App Android |
| App Store | pendiente | App iOS |
| Dominio | pendiente | trazanet.com |

## Buenas Prácticas

1. **Nunca hardcodear** credenciales en código
2. **Usar .env** para desarrollo local
3. **Secretos en CI/CD** para deploys (GitHub Secrets, Vercel env vars)
4. **Rotar keys** periódicamente
5. **Diferentes keys** por ambiente (dev/staging/prod)
