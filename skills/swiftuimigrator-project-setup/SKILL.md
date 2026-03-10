---
name: swiftuimigrator-project-setup
description: Use when a UIKit-to-SwiftUI migration still needs project-level setup such as Tuist updates, App.swift creation, SplashScreen setup, or entry-point transition from AppDelegate.
---

# SwiftUI Migrator Project Setup

## Purpose

Set up the app shell and project structure required before screen-by-screen SwiftUI migration starts.

## When to Use

- The project does not yet have a SwiftUI `App` entry point
- Tuist targets still need SwiftUI-compatible deployment target updates
- `SplashScreen.swift` and startup shell files are missing
- `AppDelegate` still owns app window bootstrap logic

## Scope

- Tuist deployment target updates
- `App.swift` creation
- Empty `SplashScreen.swift` creation
- Entry-point transition out of `AppDelegate`
- File-organization rules for migrated screens and reusable views

## Verification

- `tuist generate --no-open`
- `tuist build`
- App launches through the SwiftUI app shell without duplicate entry-point errors

## Exit Criteria

The project is ready for `swiftuimigrator-data-migration` or `swiftuimigrator-screens`.
