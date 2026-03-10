---
name: swiftuimigrator-project-setup
description: Use when a UIKit-to-SwiftUI migration still needs project-level setup such as Tuist updates, App.swift creation, SplashScreen setup, or entry-point transition from AppDelegate.
---

# SwiftUI Migrator Project Setup

## Overview

Use this skill at the start of a migration to prepare the app shell for SwiftUI without beginning screen conversion yet.

Core principle: establish a stable SwiftUI entry point first, then migrate startup work and screens on top of it.

## When to Use

- The project does not yet have a SwiftUI `App` entry point
- Tuist deployment targets still need SwiftUI-compatible updates
- `SplashScreen.swift` and the app shell are missing
- `AppDelegate` still owns launch-time window setup
- The launch screen and initial SwiftUI splash handoff are not yet aligned

## Scope

- Update Tuist deployment targets for SwiftUI support
- Create `App.swift`
- Create an empty `SplashScreen.swift`
- Move app entry ownership away from `AppDelegate`
- Apply file-organization rules for migrated screens and reusable views
- Match the launch screen visually to avoid a startup jump

## File Organization Rules

- **Screens:** Full-screen SwiftUI replacements for `UIViewController` classes belong in `Projects/App/Sources/Screens/`.
- **Views:** Smaller reusable SwiftUI components belong in `Projects/App/Sources/Views/`.
- **Naming:** Do not use generic names like `ContentView.swift`. Use descriptive names such as `MainScreen.swift` and `SplashScreen.swift`.

## Migration Tasks

### 1. Update Tuist for SwiftUI

1. Locate all `Project.swift` files under the `Projects/` directory.
2. In each file, find the `deploymentTarget`.
3. Update every module to at least `iOS 18.0`.
4. Run `tuist generate --no-open`.

### 2. Add the SwiftUI app shell

1. Create `Projects/App/Sources/App.swift` with a `WindowGroup` that shows `SplashScreen`.
2. Create `Projects/App/Sources/Screens/SplashScreen.swift`.
3. In `AppDelegate.swift`, remove `@UIApplicationMain` or `@main` and remove direct `self.window` ownership.
4. Keep `AppDelegate.swift` itself. Do not delete it during setup.

### 3. Make the splash transition seamless

1. Inspect the launch screen configuration in `Info.plist` or `LaunchScreen.storyboard`.
2. Match the same background color and image in `SplashScreen.swift`.
3. Keep image size and positioning aligned with the launch screen.

## Shared References

- Samples: `../swiftuimigrator/guides/samples/step2-app-splash/`
- Verification: `../swiftuimigrator/guides/verification-checklists.md`
- Troubleshooting: `../swiftuimigrator/guides/troubleshooting.md`

## Verification

- Run `tuist generate --no-open`
- Run `tuist build`
- Confirm there is no duplicate `@main` or `UIApplicationMain` conflict
- Confirm the app launches through the SwiftUI shell
- Confirm there is no visible jump between the system launch screen and `SplashScreen`

## Exit Criteria

The project is ready for:
- `swiftuimigrator-data-migration` if startup logic still needs to move out of UIKit
- `swiftuimigrator-screens` if the app shell is already stable enough to start screen migration
