# 📋 Guía: Configurar GitHub Organization

Sigue estos pasos una vez que tengas el email corporativo configurado.

## Paso 1: Crear la Organización

1. Ve a: https://github.com/organizations/new
2. Selecciona **"Free"** plan
3. Completa:
   - **Organization account name**: `trazanet`
   - **Contact email**: `dev@trazanetorg.com`
4. Click **"Create organization"**

## Paso 2: Configurar Git Local

Abre PowerShell y ejecuta:

```powershell
# Configurar identidad global
git config --global user.name "Tu Nombre"
git config --global user.email "dev@trazanetorg.com"

# Verificar configuración
git config --global --list
```

## Paso 3: Crear SSH Key

```powershell
# Generar key
ssh-keygen -t ed25519 -C "dev@trazanetorg.com"

# Presiona Enter para usar ubicación por defecto
# Opcionalmente agrega passphrase

# Iniciar ssh-agent
Get-Service ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent

# Agregar key al agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519

# Copiar key pública al clipboard
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard

Write-Host "Key copiada al clipboard!"
```

## Paso 4: Agregar SSH Key a GitHub

1. Ve a: https://github.com/settings/keys
2. Click **"New SSH key"**
3. Title: `TrazaNet Dev Machine`
4. Pega la key (ya está en tu clipboard)
5. Click **"Add SSH key"**

## Paso 5: Crear Repositorios

En la organización, crear repos:

### trazanet-mobile
```
Nombre: trazanet-mobile
Descripción: 📱 App móvil Flutter para trazabilidad ganadera
Privado: Sí
Add README: No (lo agregamos nosotros)
Add .gitignore: No (tenemos el nuestro)
```

### trazanet-api
```
Nombre: trazanet-api
Descripción: 🔌 Backend API para TrazaNet
Privado: Sí
```

### trazanet-web
```
Nombre: trazanet-web
Descripción: 💻 Dashboard web Angular para TrazaNet
Privado: Sí
```

### trazanet-infra
```
Nombre: trazanet-infra
Descripción: 🏗️ Infraestructura, Docker, K8s, CI/CD
Privado: Sí
```

## Paso 6: Verificar Conexión

```powershell
ssh -T git@github.com
# Debería responder: Hi trazanet! You've successfully authenticated
```

## ✅ Listo!

Ahora podés clonar y empezar a trabajar:

```powershell
git clone git@github.com:trazanetorg/trazanet-mobile.git
```
