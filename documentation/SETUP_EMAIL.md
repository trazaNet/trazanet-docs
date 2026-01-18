 # 📋 Guía: Configurar Email Corporativo

## Opción A: Google Workspace (Recomendado)

### Paso 1: Registrar
1. Ve a: https://workspace.google.com/
2. Click **"Get started"**
3. Ingresa tu dominio: `trazanet.com`

### Paso 2: Verificar Dominio
Google te dará un registro DNS para agregar. 

En tu registrador de dominio (Namecheap, Cloudflare, etc.):
1. Ve a DNS Settings
2. Agrega el registro TXT que Google te da
3. Espera 5-10 minutos
4. Verifica en Google

### Paso 3: Configurar MX Records
Agrega estos registros MX en tu dominio:

| Prioridad | Host | Value |
|-----------|------|-------|
| 1 | @ | ASPMX.L.GOOGLE.COM |
| 5 | @ | ALT1.ASPMX.L.GOOGLE.COM |
| 5 | @ | ALT2.ASPMX.L.GOOGLE.COM |
| 10 | @ | ALT3.ASPMX.L.GOOGLE.COM |
| 10 | @ | ALT4.ASPMX.L.GOOGLE.COM |

### Paso 4: Crear Usuarios
Crear estos emails:
- `dev@trazanet.com` - Para servicios (GitHub, Supabase, etc.)
- `admin@trazanet.com` - Administrador principal
- `tu-nombre@trazanet.com` - Tu email personal

---

## Opción B: Zoho Mail (Gratis)

### Paso 1: Registrar
1. Ve a: https://www.zoho.com/mail/zohomail-pricing.html
2. Selecciona **"Forever Free"**
3. Click **"Sign Up Now"**

### Paso 2: Similar a Google
- Verificar dominio con TXT record
- Configurar MX records (Zoho te da los valores)
- Crear usuarios

---

## Notas

- El email puede tardar hasta 48hs en propagarse completamente
- Para empezar, podés usar el email en GitHub y Supabase aunque aún no recibas emails
- Probá enviándote un email desde tu cuenta personal

## Después de Configurar

1. Loguea en el email: https://mail.google.com (o Zoho)
2. Configura autenticación 2FA
3. Continúa con: [SETUP_GITHUB.md](./SETUP_GITHUB.md)
