---
name: swiftuimigrator-data-migration
description: Use when SwiftUI app startup still needs initialization, migration, loading-state orchestration, AppInitializer work, or SplashScreen progress handling.
---

# SwiftUI Migrator Data Migration

## Overview

Use this skill after the SwiftUI app shell exists but before screen-by-screen migration starts. It moves initialization, data migration, and heavy startup work into the SwiftUI startup flow safely.

Core principle: complete startup stabilization before screen migration, so feature work does not carry hidden app-lifecycle risk.

## When to Use

- `AppDelegate` still owns initialization or migration logic
- Startup work needs an `AppInitializer`
- `SplashScreen` should display loading or migration progress
- Core Data to SwiftData migration is part of the move to SwiftUI
- Startup work is slow, failure-prone, or currently hard to observe

## Scope

- Inventory startup responsibilities currently in UIKit lifecycle code
- Create an `AppInitializer`
- Create a `DataMigrationManager`
- Set up `.modelContainer` when moving to SwiftData
- Move long-running startup work into the SwiftUI startup path
- Handle startup progress, failures, duplicated data, and memory concerns

## Startup Responsibilities Inventory

Before writing new SwiftUI startup logic, inspect `AppDelegate` and related setup files for:

- database initialization
- migration code
- seed-data logic
- SDK setup that must happen before the first screen
- startup dependencies that currently rely on UIKit timing

Do not begin screen migration until you know which responsibilities still need to move.

## Migration Tasks

### 1. Create startup coordinator types

1. Create `DataMigrationManager` to own data-porting logic.
2. Create `AppInitializer` to coordinate all startup tasks.
3. Keep migration and initialization responsibilities explicit rather than burying them in view lifecycle code.

### 2. Move startup flow into SwiftUI

1. Update `SplashScreen` to call the startup coordinator.
2. Show loading or migration progress as needed.
3. Ensure the app does not move into the main screen until startup is actually ready.

### 3. Handle persistence migration

1. If moving from Core Data to SwiftData, create the required SwiftData models.
2. Set up `.modelContainer` in `App.swift`.
3. Keep migration idempotent so reruns do not duplicate data.

## Failure Handling

- If startup work takes too long, surface progress rather than hiding it.
- If migration fails, keep the failure path explicit and diagnosable.
- If data appears duplicated, re-check migration idempotency and source-of-truth ownership.
- If memory spikes with large datasets, batch work and reduce retained intermediate state.

## Shared References

- Samples: `../swiftuimigrator/guides/samples/step3-data-migration/`
- Troubleshooting: `../swiftuimigrator/guides/troubleshooting.md`
- Verification: `../swiftuimigrator/guides/verification-checklists.md`

## Verification

- Startup work runs from the SwiftUI flow rather than UIKit bootstrap code
- `SplashScreen` communicates loading or migration state clearly
- Migration can complete without crashes or duplicated data
- The app reaches the first screen in a stable state

## Exit Criteria

The app shell and startup path are stable enough to begin `swiftuimigrator-screens`.
