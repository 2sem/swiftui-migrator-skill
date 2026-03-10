---
name: swiftuimigrator-data-migration
description: Use when SwiftUI app startup still needs initialization, migration, loading-state orchestration, AppInitializer work, or SplashScreen progress handling.
---

# SwiftUI Migrator Data Migration

## Purpose

Move initialization, migration, and heavy startup work into the SwiftUI startup flow safely.

## When to Use

- `AppDelegate` still owns initialization or data migration logic
- Startup work needs a dedicated `AppInitializer`
- `SplashScreen` should display migration or loading progress
- Core Data to SwiftData migration needs orchestration

## Scope

- Startup responsibility inventory
- `AppInitializer`
- `DataMigrationManager`
- `.modelContainer` setup guidance
- Splash progress and long-running startup handling

## Verification

- Startup work runs from the SwiftUI flow
- Migration progress and failure handling are explicit
- The app reaches screen migration in a stable state

## Exit Criteria

The app shell is stable enough to begin screen-by-screen SwiftUI migration.
