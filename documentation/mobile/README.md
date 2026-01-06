# 📱 TrazaNet Mobile - Documentación

Aplicación móvil de TrazaNet (Flutter) optimizada para la lectura de caravanas RFID y gestión de campo.

## ✨ Características
*   **Navegación 5 Tabs**: Inicio, Lotes, Leer, Animales, Más.
*   **Wizard de Lotes**: Flujo guiado de 4 pasos (nombre, ubicación, tipo de trabajo, categorías).
*   **Integración BLE**: Soporte nativo para lectores Baqueano.
*   **Feedback Visual**: Indicadores de conexión API y Bluetooth.

## 📡 Protocolo de Lectura (RFID)
La app procesa el formato estándar de caravanas en Uruguay:
```
A0000000858000035507089
│         │
│         └── Número único del animal
└── Prefijo país (858 = Uruguay)
```

## 🛠️ Stack Tecnológico
*   **Framework**: Flutter
*   **Gestión BLE**: `flutter_blue_plus`
*   **Red**: `http` + API centralizada

## 🚀 Guía Rápida
1.  `flutter pub get`
2.  `flutter run -d windows` (para pruebas de UI)
3.  Build iOS vía Codemagic para uso en campo.
