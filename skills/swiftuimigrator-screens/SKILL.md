---
name: swiftuimigrator-screens
description: Use when converting UIKit ViewControllers into SwiftUI screens, migrating features incrementally, rewiring navigation, or bridging complex UIKit views with UIViewRepresentable.
---

# SwiftUI Migrator Screens

## Overview

Use this skill for the repeated screen-by-screen migration loop after the app shell and startup path are stable.

Core principle: move one screen and one feature slice at a time, and compare SwiftUI behavior against the original UIKit implementation before changing architecture.

## When to Use

- A root or secondary `ViewController` needs a SwiftUI replacement
- The app shell is stable enough to begin screen conversion
- Features need to move incrementally from UIKit into SwiftUI
- Navigation must be rewritten with SwiftUI patterns
- A complex UIKit component may need a temporary `UIViewRepresentable` bridge

## Scope

- Screen selection and naming
- First-screen conversion
- Incremental feature migration
- Navigation migration
- `UIViewRepresentable` bridge cases
- Repeating the migration loop for additional screens

## Screen Selection Rules

- Start with the root or simplest high-value screen.
- Prefer a screen with limited dependencies before tackling the most complex flow.
- Migrate one screen to stable parity before moving to the next one.

## Naming and Placement

- Convert `MainViewController` into `MainScreen.swift`, not `ContentView.swift`.
- Place full-screen SwiftUI views in `Projects/App/Sources/Screens/`.
- Place smaller reusable SwiftUI pieces in `Projects/App/Sources/Views/`.

## Migration Procedure

### 1. Create the first SwiftUI screen

1. Identify the current root `ViewController`.
2. Create its SwiftUI counterpart with a descriptive `Screen` name.
3. Update the app flow so the new screen appears after startup completes.

### 2. Migrate one feature at a time

1. Choose a simple behavior from the UIKit screen.
2. Recreate that behavior in SwiftUI.
3. Verify it before moving on to the next feature.

### 3. Repeat for additional screens

1. Pick the next `ViewController`.
2. Repeat the same conversion and verification loop.
3. Track migration progress screen by screen.

## Common UIKit to SwiftUI Mappings

- `UILabel` -> `Text`
- `UIButton` -> `Button`
- `UITableView` -> `List`
- `UINavigationController` -> `NavigationLink`
- Delegates -> closures, bindings, or observable state
- Complex embedded UIKit views -> `UIViewRepresentable`

## Navigation Migration

- Move navigation patterns deliberately, not incidentally.
- Replace UIKit push/present logic with `NavigationLink`, `.sheet`, `TabView`, or other explicit SwiftUI flow state.
- Re-check initial selected state and route selection when porting tabs or multi-step flows.

## Debugging Rule

If the SwiftUI screen behaves incorrectly, **go back and re-read the original UIKit implementation before inventing a fix**.

Compare:
- initial state values
- lifecycle setup
- delegate callbacks
- configuration and property observers

## Shared References

- First screen sample: `../swiftuimigrator/guides/samples/step4-first-screen/`
- Migration patterns: `../swiftuimigrator/guides/samples/step6-migration-patterns/`
- Navigation patterns: `../swiftuimigrator/guides/samples/step7-navigation-patterns/`
- Common pitfalls: `../swiftuimigrator/guides/common-pitfalls.md`
- Troubleshooting: `../swiftuimigrator/guides/troubleshooting.md`
- Verification: `../swiftuimigrator/guides/verification-checklists.md`

## Verification

- The migrated screen compiles and appears correctly
- Each migrated feature matches UIKit behavior before the next feature starts
- Navigation still works after each migration step
- Temporary UIKit bridges are explicit and justified

## Exit Criteria

The current screen is fully migrated and the same process can safely repeat for the next screen.
