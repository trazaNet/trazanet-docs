# Deep Linking & Sharing Implementation

## Overview

This document details the architecture for the "Share Lote" feature, which allows users to share direct access to a "Lote" via a URL.

**Scheme:** `trazanet://share/lote/<LOTE_ID>`

## Architecture

### 1. Native Configuration

#### Android (`AndroidManifest.xml`)

An Intent Filter intercepts the `VIEW` action for the `trazanet` scheme.

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="trazanet" />
</intent-filter>
```

#### iOS (`Info.plist`)

Registered the URL Type to allow the OS to open the app.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>trazanet</string>
        </array>
    </dict>
</array>
```

### 2. DeepLinkService

Located at `lib/services/deep_link_service.dart`.

- **Singleton**: Manages the subscription to link events via `app_links` package.
- **Streams**: Exposes a `linkStream` that emits parsed parameters (e.g., `loteId`) to the UI.

### 3. Navigation Handling

In `lib/main.dart` -> `MainNavigation`:

- The app listens to `DeepLinkService` events.
- On event:
  1. Shows a loading feedback.
  2. Calls `ApiService.obtenerLote(id)` to fetch the lot details properly.
  3. Navigates to `LoteDetailScreen`.

### 4. UI Implementation

- **LoteDetailScreen**: Added a Share button in the AppBar.
- Uses `share_plus` to generate the link and invoke the native share sheet.

## Usage

To test via command line:

```bash
# Android
adb shell am start -W -a android.intent.action.VIEW -d "trazanet://share/lote/123" com.trazanet.app

# iOS (Simulator)
xcrun simctl openurl booted "trazanet://share/lote/123"
```
