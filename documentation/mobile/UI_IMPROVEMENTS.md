# Mobile UI/UX Improvements

## 1. Login Screen Refactor

**Goal:** Enhance perceived quality and prevent layout shifts during interaction.

- **Implemented:** `LayoutBuilder` + `SingleChildScrollView`.
- **Logic:**
  - Header (Logo) remains fixed or transitions smoothly using `AnimatedSize`.
  - Registration fields (DICOSE, Phone) appear via `SizeTransition` without "jumping".
  - Fade animations for text changes between "Login" and "Register" modes.

## 2. iPhone Navbar Fix (Floating Design)

**Goal:** Fix the "tall navbar" issue on iOS devices with home indicators.

- **Problem:** Embedding `SafeArea` *inside* the navbar container caused the white background to stretch to the bottom of the screen, breaking the floating effect.
- **Solution:**
  - Removed internal `SafeArea`.
  - Applied dynamic margin: `margin-bottom: 8 + MediaQuery.padding.bottom` (Reduced from 20 for a more compact, grounded loook).
  - Reduced internal padding and spacing to make the bar slimmer.
  - Result: The navbar floats correctly above the home indicator in a compact form.

## 3. Lote Detail & Sharing

**Goal:** Clean UI for sharing functionality.

- **Implementation:**
  - "Share" option is located within the "More Options" menu (3 dots) in the top right.
  - Tapping opens a bottom sheet with "Compartir Lote" and "Eliminar Lote" options.
  - This keeps the AppBar clean and groups actionable items logically.

## 4. Google Login Button

**Goal:** Premium look & feel for social login.

- **Old:** OutlinedButton with generic icon.
- **New:** Elevated pill-shaped button (White + Shadow).
- **Style:** Uses `GoogleFonts.roboto` (w900) to simulate the 'G' logo without external assets, matching brand colors. Text updated to "Continuar con Google".
