# 📋 Guía: Deploy API a Railway

## Paso 1: Crear cuenta en Railway

1. Andá a: https://railway.app/
2. Click **"Login"** → **"Login with GitHub"**
3. Autorizá Railway a acceder a tu GitHub

## Paso 2: Crear nuevo proyecto

1. Click **"New Project"**
2. Seleccioná **"Deploy from GitHub repo"**
3. Buscá y seleccioná `trazaNet/trazanet-api`
4. Click **"Deploy Now"**

## Paso 3: Configurar variables de entorno

En Railway, andá a tu proyecto → **Variables** y agregá:

```
NODE_ENV=production
PORT=4000
SUPABASE_URL=https://atyzbflxynprtqmqghkb.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0eXpiZmx4eW5wcnRxbXFnaGtiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc2NDk3NTUsImV4cCI6MjA4MzIyNTc1NX0.MpIOuv8xjxbMs276EiYgyVBcEL1yp2NV2_eXnHT69j0
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0eXpiZmx4eW5wcnRxbXFnaGtiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzY0OTc1NSwiZXhwIjoyMDgzMjI1NzU1fQ.M9H4iOaBAz3cduKBOtzfVkr949ohLcnomK21ke63GkM
CORS_ORIGIN=*
```

## Paso 4: Verificar deploy

1. Railway generará una URL como: `https://trazanet-api-production.up.railway.app`
2. Probá: `https://TU-URL/health`
3. Debería responder: `{"status":"ok"}`

## Notas

- Railway detecta automáticamente que es Node.js
- Ejecuta `npm install` y `npm start`
- Cada push a `main` hace deploy automático
