# TrazaNet API

Backend API para la plataforma de trazabilidad ganadera TrazaNet.

## 🔧 Tech Stack

- Node.js / TypeScript
- Express / Fastify
- Supabase (PostgreSQL)
- Docker

## 🚀 Comenzar

### Prerrequisitos

- Node.js >= 18
- pnpm (recomendado) o npm
- Docker (opcional)

### Instalación

```bash
# Clonar repositorio
git clone git@github.com:trazanet/trazanet-api.git
cd trazanet-api

# Instalar dependencias
pnpm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# Ejecutar en desarrollo
pnpm dev
```

### Con Docker

```bash
docker-compose up -d
```

## 📂 Estructura

```
src/
├── index.ts         # Entry point
├── config/          # Configuración
├── routes/          # Rutas API
├── controllers/     # Controladores
├── services/        # Lógica de negocio
├── models/          # Modelos/tipos
├── middleware/      # Middlewares
└── utils/           # Utilidades
```

## 🔌 API Endpoints

### Autenticación
- `POST /auth/login` - Login
- `POST /auth/register` - Registro

### Animales
- `GET /animales` - Listar animales
- `GET /animales/:id` - Obtener animal
- `POST /animales` - Crear animal
- `PUT /animales/:id` - Actualizar animal

### Lotes
- `GET /lotes` - Listar lotes
- `POST /lotes` - Crear lote
- `POST /lotes/:id/animales` - Agregar animales a lote

### Sincronización
- `POST /sync` - Sincronizar lecturas desde mobile

## 🔐 Autenticación

JWT tokens via Supabase Auth.

```
Authorization: Bearer <token>
```

## 📄 Licencia

Propiedad de +CríaUY. Todos los derechos reservados.
