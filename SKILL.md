---
name: swiftuimigrator
description: "A guide for incrementally migrating UIKit apps to SwiftUI, ensuring the app remains functional throughout the process. Covers converting ViewControllers, migrating data, and adopting modern SwiftUI patterns."
---

# SwiftUI Migration Workflow

This workflow provides a 9-step, incremental approach to migrate a UIKit app to SwiftUI. The core principle is to **keep all UIKit ViewControllers running until the migration is fully complete and verified.**

**Prerequisites**:
- Existing UIKit project using Tuist
- Xcode 15+
- Basic SwiftUI knowledge

## Migration Steps Overview

1.  **Update Tuist:** Configure the project for SwiftUI.
2.  **Create SwiftUI App Entry Point:** Add a SwiftUI `App` and an empty `SplashScreen`.
3.  **Implement Data Migration:** Move data loading and migration logic to the `SplashScreen`.
4.  **Migrate First Screen:** Convert the root `ViewController` to a SwiftUI `View`.
5.  **Verify First Screen:** Ensure the new screen appears correctly after the splash screen.
6.  **Implement Features Incrementally:** Port features from the `ViewController` to the SwiftUI `View` one by one.
7.  **Repeat for Other Screens:** Repeat steps 4-6 for all remaining screens.
8.  **Migrate AdMob:** Integrate AdMob after all other features are working.
9.  **Cleanup:** Remove old UIKit code once the migration is complete.

---

## Important Guidelines

### File Organization

To maintain a clean and predictable project structure, please adhere to the following file location guidelines:

-   **Screens:** All new SwiftUI views that represent a full screen (i.e., they replace a `UIViewController`) should be placed in the `Projects/App/Sources/Screens/` directory. For example, `MainViewController.swift` would be migrated to `Projects/App/Sources/Screens/MainScreen.swift`.

-   **Views:** Smaller, reusable SwiftUI components should be placed in a `Projects/App/Sources/Views/` directory.

-   **Do not use generic names:** Avoid default names like `ContentView.swift`. Name your files descriptively.

### When you encounter issues with the SwiftUI implementation:

**CRITICAL**: If the SwiftUI version has a problem you can't solve, **go back and re-read the original UIKit ViewController implementation.**

The UIKit ViewControllers are kept throughout migration specifically so you can reference them when issues arise. When debugging:

1. **Re-examine the UIKit code**: Open the original `ViewController` and look for what you might have missed
2. **Compare implementations**: What did UIKit have that's missing in SwiftUI? (state, delegates, lifecycle, configuration)
3. **Common missed items**: 
   - Initial state values (e.g., `tabBarController.selectedIndex = 1` → need `@State var selectedTab = 1`)
   - Lifecycle initialization (`viewDidLoad` → `.task` or `.onAppear`)
   - Delegate methods → Callbacks or `@Binding`
   - Property observers → `@Published` or manual tracking

**Example**: If TabView doesn't show the correct tab, check if UITabBarController had `selectedIndex` set - you'll need `TabView(selection: $selectedTab)` with `.tag()` modifiers.

See [Troubleshooting Guide](guides/troubleshooting.md) for detailed strategies.

---

## Step 1: Update Tuist for SwiftUI
**Purpose:** Enable SwiftUI support in your Tuist project.

**Tasks:**
1.  Open `Projects/App/Project.swift`.
2.  Set the deployment target to `iOS 18.0` or higher.
3.  Run `tuist generate --no-open` to apply changes.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-1-update-tuist-for-swiftui).

---

## Step 2: Add App and Empty SplashScreen
**Purpose:** Create the SwiftUI app entry point and a splash screen for initialization.

**Tasks:**
1.  Create `Projects/App/Sources/App.swift` with a `WindowGroup` containing `SplashScreen`. (Sample: `guides/samples/step2-app-splash/App.swift`)
2.  Create an empty `Projects/App/Sources/Screens/SplashScreen.swift`. (Sample: `guides/samples/step2-app-splash/SplashScreen.swift`)
    > **Important**: The file must be created at the exact path `Projects/App/Sources/Screens/SplashScreen.swift`. This ensures consistency in the project structure.
3.  In `AppDelegate.swift`, remove the `@UIApplicationMain` or `@main` attribute and all `self.window` management code. **Do not delete the file.**
4.  Run `mise x -- tuist generate --no-open && tuist build`.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-2-add-app-and-empty-splashscreen).

---

## Step 3: Implement Data Migration & Loading
**Purpose:** Move all app initialization, data migration, and heavy loading into the `SplashScreen`.

**Tasks:**
1.  Identify initialization code in `AppDelegate` (e.g., database setup, migrations).
2.  If migrating from Core Data to Swift Data, create Swift Data models and set up the `.modelContainer` in `App.swift`.
3.  Create a `DataMigrationManager` to handle data porting. (Sample: `guides/samples/step3-data-migration/DataMigrationManager.swift`)
4.  Create an `AppInitializer` to centralize all setup tasks. (Sample: `guides/samples/step3-data-migration/AppInitializer.swift`)
5.  Update `SplashScreen` to use `AppInitializer` and display progress. (Sample: `guides/samples/step3-data-migration/SplashScreenWithMigration.swift`)

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-3-implement-data-migration--loading-process).

---

## Step 4: Create First Screen from Root ViewController
**Purpose:** Migrate the root `ViewController` to a SwiftUI `View`.

**Tasks:**
1.  Identify the root `ViewController` in your `AppDelegate` or `SceneDelegate`.
2.  Create a corresponding SwiftUI `View` (e.g., `MainViewController` -> `MainScreen.swift`). **Do not use `ContentView.swift`.**
3.  Implement the screen's UI and state management in SwiftUI. (Sample: `guides/samples/step4-first-screen/MainScreen.swift`)
4.  In `App.swift`, update the view hierarchy to show `MainScreen` after the splash screen finishes.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-4-create-first-screen-from-root-viewcontroller).

---

## Step 5: Verify First Screen
**Purpose:** Ensure the splash-to-main-screen transition works correctly.

**Tasks:**
1.  Build and run the app (`tuist build` or Cmd+R).
2.  Confirm the splash screen appears, initialization runs, and the main screen is displayed without errors.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-5-verify-first-screen-appears-after-splash).

---

## Step 6: Implement Features Incrementally
**Purpose:** Migrate features from the `ViewController` to the new SwiftUI `Screen`, one by one.

**Tasks:**
1.  Choose a simple feature from the original `ViewController`.
2.  Implement its equivalent in SwiftUI, referencing the original UIKit code.
3.  Use common migration patterns (e.g., `UITableView` -> `List`, `UINavigationController` -> `NavigationLink`, `Delegates` -> `Closures`). See samples in `guides/samples/step6-migration-patterns/`.
4.  If a UIKit view is too complex to rewrite, wrap it using `UIViewRepresentable`.
5.  Test each feature after migration before starting the next.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-6-implement-features-in-the-first-screen-one-by-one).

---

## Step 7: Repeat for Next Screen
**Purpose:** Continue the migration process for all remaining screens.

**Tasks:**
1.  Choose the next `ViewController` to migrate.
2.  Repeat **Steps 4-6** for this screen.
3.  Implement navigation between screens using SwiftUI patterns like `NavigationLink`, `.sheet`, and `TabView`. (Sample: `guides/samples/step7-navigation-patterns/NavigationExamples.swift`)
4.  Track your progress with a checklist of all screens.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-7-pick-next-screen--repeat-step-4-6).

---

## Step 8: Migrate AdMob
**Purpose:** Integrate AdMob after all app features are functional in SwiftUI.

**Tasks:**
- Follow the detailed instructions in the **AdMob Sub-Guide**: `guides/admob-migration.md`.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-8-migrate-admob-after-all-features-implemented).

---

## Step 9: Cleanup
**Purpose:** Remove legacy UIKit code after the SwiftUI migration is complete and verified.

**Tasks:**
1.  Create a backup branch of your UIKit code (`git checkout -b backup-uikit-code`).
2.  Delete the migrated `ViewController` files and storyboards.
3.  Clean up any remaining UIKit-specific code from your `AppDelegate`.
4.  Run `mise x -- tuist generate --no-open && tuist build` and perform a final, full-app test.

**Verification:** See [Verification Checklists](guides/verification-checklists.md#step-9-keep-all-viewcontrollers-until-migration-done).