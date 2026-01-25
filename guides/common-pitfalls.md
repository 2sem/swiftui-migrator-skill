# Common Pitfalls in SwiftUI Migration

This document outlines common pitfalls to avoid during a UIKit to SwiftUI migration.

## During Migration

**Pitfall: Creating ContentView.swift instead of meaningful screen names**
- **Problem**: Agent creates generic `ContentView.swift` (Xcode template) instead of actual screen names
- **Solution**: Create screens based on ViewControllers: `MainScreen.swift`, `HomeScreen.swift`, etc.
- **Why**: Migration should use meaningful names from existing app, not templates
- **Correct**: `MainScreen.swift`, `SettingsScreen.swift` (based on MainViewController, SettingsViewController)
- **Wrong**: `ContentView.swift` (generic, meaningless in migration context)

**Pitfall: Naming App file incorrectly (e.g., `MyAppApp.swift`)**
- **Problem**: Agent creates file named after project instead of `App.swift`
- **Solution**: Always name the file `App.swift`, struct inside can be `MyAppApp`
- **Why**: Consistency across projects, simpler file structure
- **Correct**: File = `App.swift`, Struct = `MyAppApp: App`
- **Wrong**: File = `MyAppApp.swift`

**Pitfall: Duplicate @main error - "@UIApplicationMain and @main cannot coexist"**
- **Problem**: Both SwiftUI App struct and AppDelegate have entry point attributes
- **Solution**: Remove `@UIApplicationMain` or `@main` from AppDelegate, keep only `@main` on App struct
- **Critical**: This is a compilation error that blocks the entire migration at Step 2

**Pitfall: AppDelegate crashes with "Fatal error: Unexpectedly found nil while unwrapping an Optional value"**
- **Problem**: AppDelegate tries to access `self.window` but SwiftUI manages the window now
- **Solution**: Remove all `self.window` usage from AppDelegate and SceneDelegate (see Step 2)
- **Critical**: This is the #1 runtime crash when adding SwiftUI to UIKit apps

**Pitfall: Deleting UIKit code too early**
- **Problem**: You lose reference implementation and can't debug issues by comparing with UIKit
- **Solution**: Follow Step 9, keep everything until done
- **Why**: UIKit ViewControllers are your source of truth when SwiftUI implementation has issues

**Pitfall: Not re-checking UIKit implementation when stuck**
- **Problem**: SwiftUI version has issues and you can't figure out why
- **Solution**: **Go back and re-read the original UIKit ViewController**
- **Critical**: When debugging SwiftUI issues, always compare with the UIKit implementation to find what was missed
- **Common missed items**:
  - Initial state (e.g., `selectedIndex`, default values)
  - Lifecycle logic (`viewDidLoad`, `viewWillAppear`)
  - Delegate methods that need SwiftUI equivalents
  - Property observers (`didSet`) → need `@Published` or manual tracking
  - Configuration (navigation bar, tab bar items)
- **Example**: TabView not showing correct tab? Check if `UITabBarController` had `selectedIndex` set
- **Remember**: The UIKit code is kept specifically so you can reference it when issues arise

**Pitfall: Trying to migrate everything at once**
- **Problem**: Overwhelming, hard to debug
- **Solution**: Follow Steps 4-7, one screen at a time

**Pitfall: Skipping verification steps**
- **Problem**: Issues accumulate, hard to find root cause
- **Solution**: Build and test after each feature

**Pitfall: Mixing UIKit and SwiftUI navigation**
- **Problem**: Confusing navigation stack
- **Solution**: Use full SwiftUI navigation once a screen is migrated

## Project Structure

**Pitfall: Forgetting to regenerate after new files**
- **Problem**: "Cannot find in scope" errors
- **Solution**: Always run `tuist generate` after creating files

**Pitfall: Wrong deployment target**
- **Problem**: SwiftUI features not available
- **Solution**: Ensure iOS 14.0+ in Step 1

## State Management

**Pitfall: Not using @Published or @State**
- **Problem**: UI doesn't update
- **Solution**: Use proper property wrappers for reactive state

**Pitfall: Mutating state outside @MainActor**
- **Problem**: Purple runtime warnings, crashes
- **Solution**: Use `@MainActor` on classes, `Task { @MainActor in ... }`

## Performance

**Pitfall: Doing heavy work in body**
- **Problem**: Laggy UI, poor performance
- **Solution**: Use `.task`, `.onAppear`, or view models

**Pitfall: Creating new objects in body**
- **Problem**: Excessive memory usage
- **Solution**: Use `@StateObject`, `@ObservedObject`, or `let` constants
