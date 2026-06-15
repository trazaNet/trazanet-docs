# TrazaNet Web

Dashboard web para la plataforma de trazabilidad ganadera TrazaNet.

## 🔧 Tech Stack

- Angular 19+
- TypeScript
- Tailwind CSS
- Supabase

## 🚀 Comenzar

### Prerrequisitos

- Node.js >= 18
- Angular CLI >= 19

### Instalación

```bash
# Clonar repositorio
git clone git@github.com:trazanet/trazanet-web.git
cd trazanet-web

# Instalar dependencias
npm install

# Configurar variables de entorno
cp src/environments/environment.example.ts src/environments/environment.ts
# Editar con tus credenciales de Supabase

# Ejecutar en desarrollo
npm start
```

### Build

```bash
npm run build
```

## 📂 Estructura

```
src/
├── app/
│   ├── components/      # Componentes reutilizables
│   ├── pages/           # Páginas/vistas
│   ├── services/        # Servicios
│   ├── guards/          # Route guards
│   └── models/          # Interfaces/tipos
├── assets/              # Recursos estáticos
├── environments/        # Config por ambiente
└── styles.css           # Estilos globales
```

## 🎨 Funcionalidades

- ✅ Dashboard con estadísticas
- ✅ Gestión de lotes
- ✅ Historial de animales
- ✅ Reportes y planillas
- ✅ Administración de usuarios
- ✅ Modo oscuro

## 📄 Licencia

Propiedad de +CríaUY. Todos los derechos reservados.
