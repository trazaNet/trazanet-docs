# SNIG Export Specification (TXT)

## Overview

TrazaNet allows exporting animal readings (Guías) to a TXT file compatible with the **Sistema Nacional de Información Ganadera (SNIG)**.

## Format Specification

The file is a plain text file where each line represents a single animal reading (tag).

### Record Structure

Each line MUST follow this specific format:
`A0000000` + `[Caravana ID]`

- **Prefix:** `A0000000` (8 characters, fixed).
- **Suffix:** The scanned tag ID (variable length, usually 15 digits for RFID).
- **Total Length:** Typically 23 characters/digits.

### Example

If the scanned RFID is `858000058060716`:
**Output Line:** `A0000000858000058060716`

## Implementation Details

- **File:** `lib/widgets/guia_download_dialog.dart`
- **Logic:** The prefix is appended before writing to the file stream.
- **Sharing:** The generated file is shared via `share_plus` to allow saving to Drive, sending via WhatsApp, or emailing.
