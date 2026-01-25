# swiftuimigrator

**Description**: Migrates UIKit AdMob integration to SwiftUI, including ad managers, user defaults, and screen-level ad presentation logic.

**When to use**: When migrating a UIKit screen with Google AdMob interstitial or opening ads to SwiftUI.

**Prerequisites**: Requires existing UIKit AdMob implementation and GADManager package.

---

# SwiftUI Migration Workflow

This workflow guides the migration of a feature from UIKit to SwiftUI, focusing on AdMob integration.

## Paths
- **Samples**: .claude/skills/swiftuimigrator/samples/admob/

## Rules
- **Avoid Duplication**: Before performing any modification or addition, always check if code is already same to the result. If it exists or is already in the desired state, skip the corresponding step and proceed to the next.
- **Error Reporting**: If any step encounters an unrecoverable error or an unexpected state, report the issue clearly and suggest manual intervention with specific file:line references.
- **Progress Tracking**: Use Claude Code's TodoWrite tool to create and update task list throughout the migration process.

## Prerequisites (One-time setup)
Before using this workflow for the first time, ensure:

1. **Install GADManager 1.3.8+**
    - Purpose: Install GADManager package to use GADManager helper for AdMob integration
    - Result: App Project Manifest has `GADManager` as package
    - Open `Projects/App/Project.swift`
    - Add to `packages` array:
     ```swift
     .remote(url: "https://github.com/2sem/GADManager",
             requirement: .upToNextMajor(from: "1.3.8")),
     ```

## Ensure User Defaults Definition

1. **Find User Defaults Wrapper File**:
    - Purpose: Locate the project's UserDefaults wrapper (naming varies by project)
    - Search for files matching pattern `*Defaults.swift` in `Projects/App/Sources/`
    - Common names: `LSDefaults.swift`, `AppDefaults.swift`, `UserDefaults.swift`, `Defaults.swift`
    - If no wrapper exists, create one following the sample `LSDefaults.swift` pattern
    - For the rest of this section, use `{DefaultsName}` to refer to the found class name

Open the found defaults file (e.g., `Projects/App/Sources/Data/AppDefaults.swift`)
Refer to `LSDefaults.swift` in Samples for structure reference

2. **Add User Defaults for Ad Permission**:
    - Purpose: Define User Defaults Names for checking whether to show Ads and to request tracking permission
    - Result: The `Keys` enum (or equivalent) contains `LaunchCount` and `AdsTrackingRequested`
    - Add to `Keys` names: `LaunchCount`, `AdsTrackingRequested`
    - Add Static Computed Properties: `AdsTrackingRequested`, `LaunchCount`
    - Note: Adapt to the existing pattern in the file (some projects use enum, others use struct)

3. **Add User Defaults for Opening Ad**:
    - Purpose: Define User Defaults Names for checking whether to show Opening Ads
    - Result: The `Keys` enum (or equivalent) contains `LastOpeningAdPrepared`
    - Add to `Keys` name: `LastOpeningAdPrepared`
    - Add Static Computed `LastOpeningAdPrepared` Property
    - Note: If the project also needs `LastFullADShown`, add it here following the existing pattern

## Create AdManager for SwiftUI

**Important**: The sample code uses `LSDefaults` as the UserDefaults wrapper class name. Replace all instances of `LSDefaults` with your project's actual defaults class name (e.g., `AppDefaults`, `UserDefaults`, etc.) found in the previous section.

1. **Create SwiftUIAdManager**:
    - Purpose: Create AdManager for SwiftUI 
    - Result: `SwiftUIAdManager` class exists
    - Create `Projects/App/Sources/Managers/SwiftUIAdManager.swift`
    - Copy the content from `samples/admob/SwiftUIAdManager.swift`
    - **IMPORTANT**: Replace all `LSDefaults` references with your project's defaults class name

2. **Conform SwiftUIAdManager to GADManagerDelegate**
    - Purpose: Store/Restore Last Ad Shown/Prepared Time
    - Result: `SwiftUIAdManager` is conformed to `GADManagerDelegate` and implemented all methods from `Projects/App/Sources/AppDelegate.swift`
    - Open `Projects/App/Sources/Managers/SwiftUIAdManager.swift`
    - Add Methods to implement `GADManagerDelegate` from `Projects/App/Sources/AppDelegate.swift`

### Verification
After completing this section, verify:
- [ ] `SwiftUIAdManager.swift` compiles without errors
- [ ] Class conforms to `GADManagerDelegate` protocol
- [ ] All delegate methods are implemented

## Migrate Google Ad Unit Names for SwiftUI

1. **Create GADUnitName.swift**:
    - Purpose: Define Enum for accessing Google Ad Units
    - Result: `GADUnitName.swift` file exists
    - Create `Projects/App/Sources/Extensions/Ad/GADUnitName.swift`
    - Copy the content from `samples/admob/GADUnitName.swift`
    - Add GADUnitName `cases` from `GADUnitIdentifiers` of `Projects/App/Project.swift`

### Verification
After completing this section, verify:
- [ ] `GADUnitName.swift` compiles without errors
- [ ] All ad units from `GADUnitIdentifiers` are represented as enum cases
- [ ] `testUnits` array contains all cases for DEBUG builds

## Migrate Admob Manager Intialization

Open `Projects/App/Sources/App.swift`
Use the content from `.claude/skills/swiftuimigrator/samples/admob/App.swift` as a reference.

**Important**: Replace `LSDefaults` in the sample with your project's actual defaults class name.

1. **Import Google Mobile Ads Framework**
    - Purpose: Import Google Ads framework to access Ads classes
    - Result: `GoogleMobileAds` imported
    - Add `import` GoogleMobileAds framework
2. **Add isSetupDone State**
    - Purpose: Define state to check Google Ads is ready
    - Result: `App.swift` as `isSetupDone` state
    - Add `isSetupDone` state as `false`
3. **Add setupAds method**
    - Purpose: Define method to ready Google Ads
    - Result: `App.swift` as `setupAds` method
    - Add `setupAds` method
4. **Add handleScenePhaseChange method**
    - Purpose: Define method to detect app life cycle
    - Result: `App.swift` as `handleScenePhaseChange` method
    - Add `handleScenePhaseChange` method
5. **Add handleAppDidBecomeActive method**
    - Purpose: Define method to handle when app become active
    - Result: `App.swift` as `handleAppDidBecomeActive` method
    - Add `handleAppDidBecomeActive` method

### Verification
After completing this section, verify:
- [ ] `App.swift` compiles without errors
- [ ] GoogleMobileAds framework is imported
- [ ] AdManager is initialized and passed as environmentObject
- [ ] App builds successfully with `tuist build`

## Migrate Interstial Ad

**Note**: While the screen uses `@AppStorage` properties, ensure the property names match those defined in your UserDefaults wrapper (e.g., `LaunchCount`, `LastFullAdShown`).

1. **Find Which ViewController and Button showing Full Ad**
    - Find calling show method of sharedGADManager
    - example: "sharedGADManager?.show(unit: .full)"

2. **Find Which SwiftUI Screen is migrated from the ViewController**
    - Find {Name}Screen if the view controller's name is {Name}ViewController

3. **Add SwiftUIAdManager as EnvironmentObject**
    - Purpose: Enable adManager in the screeen
    - Result: The screen has `adManager` EnvironmentObject
    - Open the screen file `Projects/App/Sources/.../...Screen.swift`
    - Add EnvironmentObject `adManager`
    - Use the content from `samples/admob/MigratedScreen.swift` as a reference.

4. **Add LaunchCount User Defaults Property**
    - Purpose: To request Ads permission and Ads since second Launch 
    - Result: The screen has `LaunchCount` AppStorage property
    - Open the screen file `Projects/App/Sources/.../...Screen.swift`
    - Use the content from `samples/admob/MigratedScreen.swift` as a reference.

5. **Add a Method to wrap the behavior with Ads**
    - Purpose: Extract the code invoking Ads as a method
    - Result: The screen has `presentFullAdThen` method
    - Open the screen file `Projects/App/Sources/.../...Screen.swift`
    - Add Method `presentFullAdThen`
    - Use the content from `samples/admob/MigratedScreen.swift` as a reference.

6. **Find the Code migrated from ViewController**
    - Purpose: To determine where to wrap with Ads
    - Find Which Button or Gesture migrated from the view controller
    - examples: MainViewController.onDonate to MainScreen's Button("Donate") {}

7. **Wrap the code with presentFullAdThen**
    - Purpose: To show Ads before the action
    - Result: The code wrapped with `presentFullAdThen`
    - Wrap the code found in Step 6 with `presentFullAdThen`

### Verification
After completing this section, verify:
- [ ] Screen compiles without errors
- [ ] `adManager` environmentObject is available
- [ ] `launchCount` AppStorage property is defined
- [ ] `presentFullAdThen` method wraps the target action
- [ ] Ad shows only when `launchCount > 1`
- [ ] App runs and ads display correctly

## Common Pitfalls

### Project Generation
- **Forgetting to regenerate**: After creating `SwiftUIAdManager.swift` or `GADUnitName.swift`, always run `mise x -- tuist generate --no-open`
- **Build errors after file creation**: If you see "cannot find in scope" errors, regenerate the project

### EnvironmentObject Issues
- **Missing EnvironmentObject**: Screens will crash at runtime if `.environmentObject(adManager)` is not added in the parent view hierarchy
- **Wrong injection point**: Ensure `adManager` is injected at the WindowGroup level in App.swift, not in individual screens

### Ad Display Logic
- **LaunchCount logic**: Ads only show when `launchCount > 1` - ensure this matches your UIKit behavior
- **First launch behavior**: Remember that `canShowFirstTime` flag controls whether opening ads show on first launch
- **Tracking permission timing**: `AdsTrackingRequested` prevents duplicate permission requests

### Async Context
- **State mutations in Task{}**: `presentFullAdThen` uses `Task{}` for async ad calls - be careful with @State mutations
- **Action timing**: Actions wrapped in `presentFullAdThen` execute AFTER the ad completes or is dismissed

### Testing
- **Test ads not showing**: Verify your device ID is in `testDeviceIdentifiers` in App.swift
- **DEBUG vs RELEASE intervals**: Opening ads use different intervals (60s DEBUG vs 5min RELEASE)
- **testUnits array**: Ensure all GADUnitName cases are listed in `testUnits` for DEBUG builds
