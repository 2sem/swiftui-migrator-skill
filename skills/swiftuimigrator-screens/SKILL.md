---
name: swiftuimigrator-screens
description: Use when converting UIKit ViewControllers into SwiftUI screens, migrating features incrementally, rewiring navigation, or bridging complex UIKit views with UIViewRepresentable.
---

# SwiftUI Migrator Screens

## Purpose

Handle the repeated screen-by-screen conversion from UIKit to SwiftUI while preserving feature parity.

## When to Use

- The app shell and startup path are already stable
- A root or secondary `ViewController` needs SwiftUI conversion
- Features need to move one by one from UIKit into a SwiftUI screen
- Navigation must be rewritten with SwiftUI patterns

## Scope

- Screen selection and naming
- First-screen conversion
- Incremental feature migration
- Navigation migration
- `UIViewRepresentable` bridge cases

## Verification

- The migrated screen compiles and appears correctly
- Migrated features behave like the UIKit implementation
- Navigation works correctly after each change

## Exit Criteria

One screen is fully migrated and the process is ready to repeat for the next screen.
