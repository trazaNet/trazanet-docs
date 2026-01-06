# TrazaNet Mobile

Aplicación móvil de trazabilidad ganadera para Uruguay.

## 📱 Plataformas

- ✅ Android
- ✅ iOS

## 🔧 Tech Stack

- Flutter
- Dart
- Bluetooth Low Energy (BLE)
- Supabase

## 🚀 Comenzar

### Prerrequisitos

- Flutter SDK >= 3.0
- Android Studio / Xcode
- Cuenta de Supabase

### Instalación

```bash
# Clonar repositorio
git clone git@github.com:trazanet/trazanet-mobile.git
cd trazanet-mobile

# Instalar dependencias
flutter pub get

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales de Supabase

# Ejecutar en desarrollo
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

## 📂 Estructura

```
lib/
├── main.dart
├── config/          # Configuración de app
├── models/          # Modelos de datos
├── services/        # Servicios (BT, API, Storage)
├── screens/         # Pantallas
├── widgets/         # Widgets reutilizables
└── utils/           # Utilidades
```

## 🔗 Bluetooth

La app se conecta con lectores RFID vía Bluetooth para leer caravanas electrónicas.

Formato de caravana Uruguay:
```
A0000000858XXXXXXXXXXXX
         └── 858 = Código país Uruguay
```

## 📄 Licencia

Propiedad de +CríaUY. Todos los derechos reservados.
