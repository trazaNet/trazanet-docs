# 📋 Guía: Migrar bt-test-app a trazanet-mobile

Esta guía asume que ya tenés:
- ✅ GitHub org creada
- ✅ Repo `trazanet-mobile` creado (vacío)
- ✅ SSH key configurada

## Paso 1: Clonar Repo Vacío

```powershell
# Ir a tu carpeta de proyectos (puede ser nueva ubicación)
cd C:\Users\juanm\OneDrive\Desktop\Proyectos

# Clonar el repo vacío
git clone git@github.com:trazanetorg/trazanet-mobile.git

cd trazanet-mobile
```

## Paso 2: Copiar Archivos de bt-test-app

```powershell
# Volver a la carpeta de trazaNet
cd C:\Users\juanm\OneDrive\Desktop\Proyectos\trazaNet

# Copiar archivos (EXCLUYENDO .git, build, etc.)
$source = "bt-test-app"
$dest = "..\trazanet-mobile"

# Archivos a excluir
$exclude = @(".git", "build", ".dart_tool", ".idea", "ios/Pods", "android/.gradle")

# Copiar todo excepto los excluidos
Get-ChildItem -Path $source -Exclude $exclude | Copy-Item -Destination $dest -Recurse -Force

# Copiar archivos ocultos necesarios (como .gitignore original)
Copy-Item "$source\.gitignore" "$dest\.gitignore" -Force
Copy-Item "$source\.metadata" "$dest\.metadata" -Force
```

O manualmente:
1. Abrir `bt-test-app` en Explorer
2. Seleccionar TODO excepto: `.git/`, `build/`, `.dart_tool/`
3. Copiar a la nueva carpeta `trazanet-mobile`

## Paso 3: Actualizar Identificadores

### Android (`android/app/build.gradle`)
Buscar y cambiar:
```gradle
// Antes
applicationId "com.example.ble_latency_tester"

// Después
applicationId "com.criuy.trazanet"
```

### iOS (`ios/Runner.xcodeproj/project.pbxproj`)
Buscar y cambiar `PRODUCT_BUNDLE_IDENTIFIER`:
```
// Antes
PRODUCT_BUNDLE_IDENTIFIER = com.example.bleLatencyTester;

// Después
PRODUCT_BUNDLE_IDENTIFIER = com.criuy.trazanet;
```

### pubspec.yaml
```yaml
# Cambiar nombre
name: trazanet_mobile
description: App móvil de trazabilidad ganadera para Uruguay
```

## Paso 4: Copiar Templates

```powershell
cd C:\Users\juanm\OneDrive\Desktop\Proyectos\trazanet-mobile

# Copiar README nuevo
Copy-Item "..\trazaNet\documentation\templates\trazanet-mobile\README.md" ".\README.md" -Force

# Copiar .env.example
Copy-Item "..\trazaNet\documentation\templates\trazanet-mobile\.env.example" ".\.env.example"
```

## Paso 5: Commit y Push

```powershell
cd C:\Users\juanm\OneDrive\Desktop\Proyectos\trazanet-mobile

# Agregar todos los archivos
git add .

# Commit inicial
git commit -m "feat: initial migration from bt-test-app

- Migrated working Flutter BLE app
- Updated package identifiers to com.criuy.trazanet
- Tested on iOS and Android"

# Push
git push origin main
```

## Paso 6: Verificar

```powershell
# Obtener dependencias
flutter pub get

# Verificar que compila
flutter build apk --debug

# Correr en emulador
flutter run
```

## ✅ Listo!

El proyecto está migrado. Próximos pasos:
- Actualizar íconos de app
- Configurar Supabase
- Actualizar UI con branding TrazaNet
