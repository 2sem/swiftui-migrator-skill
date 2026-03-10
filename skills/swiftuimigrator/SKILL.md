---
name: swiftuimigrator
description: Use when planning or coordinating an incremental UIKit-to-SwiftUI migration and you need to determine which migration stage or specialized subskill should run next.
---

# SwiftUI Migrator

## Overview

This is the orchestrator for incremental UIKit-to-SwiftUI migration. Use it to detect the current migration stage, apply global safety rules, and route work to the correct specialized subskill.

Core principle: **keep UIKit ViewControllers running until the SwiftUI migration is fully complete and verified.**

## Migration Stages

1. **Project setup**
   Route to `swiftuimigrator-project-setup`
2. **Data migration and startup loading**
   Route to `swiftuimigrator-data-migration`
3. **Screen-by-screen migration**
   Route to `swiftuimigrator-screens`
4. **AdMob migration**
   Route to `swiftuimigrator-admob`
5. **Final cleanup**
   Route to `swiftuimigrator-cleanup`

## Stage Detection

### Use `swiftuimigrator-project-setup` when:

- The project does not yet have a SwiftUI `App` entry point
- Tuist deployment targets still need SwiftUI-compatible updates
- `SplashScreen.swift` and the app shell are not in place
- `AppDelegate` still owns launch-time window setup

### Use `swiftuimigrator-data-migration` when:

- Startup logic still lives in `AppDelegate`
- Data migration or initialization must move into the SwiftUI startup path
- `SplashScreen` should show migration or loading progress
- SwiftData container setup is part of the migration

### Use `swiftuimigrator-screens` when:

- The app shell is stable enough to begin screen conversion
- A `ViewController` needs to become a SwiftUI screen
- Features need to move incrementally from UIKit into SwiftUI
- Navigation must be rewritten with SwiftUI patterns
- A complex UIKit view may need a temporary `UIViewRepresentable` bridge

### Use `swiftuimigrator-admob` when:

- Core screen migration is already working
- The remaining work is specific to Google AdMob
- `SwiftUIAdManager`, ad-unit migration, or native ad views still need SwiftUI equivalents

### Use `swiftuimigrator-cleanup` when:

- All required screens and features are already migrated
- The remaining work is deleting legacy UIKit files and entry logic
- Final verification has already passed and cleanup is now safe

## Routing Map

- Missing SwiftUI app shell: `swiftuimigrator-project-setup`
- Startup initialization or data migration work: `swiftuimigrator-data-migration`
- Root or secondary screen migration: `swiftuimigrator-screens`
- AdMob after the app is otherwise stable: `swiftuimigrator-admob`
- Final removal of UIKit migration scaffolding: `swiftuimigrator-cleanup`

## Global Rules

### File Organization

- **Screens:** New SwiftUI screens that replace `UIViewController` classes belong in `Projects/App/Sources/Screens/`.
- **Views:** Smaller reusable SwiftUI components belong in `Projects/App/Sources/Views/`.
- **Naming:** Do not use generic names like `ContentView.swift`. Use descriptive names such as `MainScreen.swift`.

### Migration Safety

- Migrate incrementally, one stage and one screen at a time.
- Keep all UIKit `ViewController` implementations until the full migration is verified.
- Do not run AdMob migration before setup, startup flow, and screen migration are stable.
- Do not start cleanup until the SwiftUI app is fully verified end to end.

### Debugging Principle

If the SwiftUI version has a problem you cannot solve, **go back and re-read the original UIKit implementation**.

Compare:
- initial state values
- lifecycle setup
- delegate behavior
- configuration and property observers

Example:
- If `TabView` does not open on the correct tab, check whether the UIKit implementation set `selectedIndex` and mirror that state explicitly in SwiftUI.

For detailed troubleshooting strategies, see `guides/troubleshooting.md`.

## Recommended Flow

1. Detect the current migration stage.
2. Route to the appropriate specialized subskill.
3. Complete that stage and verify it before moving on.
4. Repeat until all screens and supporting systems are migrated.
5. Run cleanup only after the full SwiftUI app is stable.
