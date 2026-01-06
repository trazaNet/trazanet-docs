# TrazaNet API - Documentación Centralizada

Backend de TrazaNet, encargado de la gestión de animales, lotes y sincronización de lecturas RFID.

## 🛠️ Stack Tecnológico

*   **Runtime**: Node.js
*   **Lenguaje**: TypeScript
*   **Framework**: Express.js
*   **Base de Datos**: PostgreSQL (vía Supabase)
*   **Despliegue**: [Render](https://trazanet-api.onrender.com)

## 🚀 Instalación y Setup local

1.  **Clonar el repositorio**: `github.com/trazaNet/trazanet-api`
2.  **Instalar**: `npm install`
3.  **Configurar**: `.env` (ver `.env.example` en el repo)
4.  **Correr**: `npm run dev`

## 📡 Endpoints principales

| Método | Ruta | Descripción |
| :--- | :--- | :--- |
| `GET` | `/health` | Estado de la API |
| `GET` | `/api/animales` | Lista animales |
| `POST` | `/api/animales` | Registra animal |
| `GET` | `/api/lotes` | Lista lotes |
| `POST` | `/api/lotes` | Crea lote |
| `POST` | `/api/lecturas` | Registra lecturas |

## 📦 Despliegue
Deploy automático en Render desde la rama `main`.
URL: [https://trazanet-api.onrender.com](https://trazanet-api.onrender.com)
