# Troubleshooting SwiftUI Migration

This guide provides solutions to common issues encountered during a UIKit to SwiftUI migration.

---

## General Troubleshooting Strategy

### When the SwiftUI version has an issue you can't solve:

**CRITICAL STRATEGY**: Go back and re-examine the original UIKit implementation.

1. **Re-read the UIKit ViewController**:
   - Open the original `ViewController` file
   - Carefully review what the UIKit version was doing
   - Look for implementation details you might have missed

2. **Compare UIKit vs SwiftUI**:
   - What did the UIKit version have that's missing in SwiftUI?
   - Are there properties, state variables, or delegates that weren't migrated?
   - Did the UIKit version have special initialization, lifecycle methods, or timing logic?

3. **Common things that get missed**:
   - `viewDidLoad()` initialization → Should be in `.task` or `.onAppear`
   - `viewWillAppear()` → `.onAppear` or `.task`
   - Delegate methods → Need equivalent callbacks or `@Binding`
   - Property observers (`didSet`, `willSet`) → Need to use `@Published` or manual observers
   - UIKit-specific state (selected index, scroll position) → Need `@State` variables
   - Timer or notification setup → Need SwiftUI lifecycle equivalents
   - Navigation bar configuration → Need `.toolbar` or `.navigationBarItems`

4. **Example debugging workflow**:
   ```
   Problem: TabView doesn't show the correct initial tab
   
   Step 1: Open UITabBarController implementation
   Step 2: Find: tabBarController.selectedIndex = 1
   Step 3: Realize: We missed setting the initial tab in SwiftUI
   Step 4: Add: @State private var selectedTab = 1
   Step 5: Add: TabView(selection: $selectedTab) { ... }
   Step 6: Add: .tag(0), .tag(1), .tag(2) to each tab
   ```

5. **What to look for in UIKit code**:
   - **Properties**: Instance variables that hold state
   - **Lifecycle**: `viewDidLoad`, `viewWillAppear`, `viewDidAppear`, `viewWillDisappear`
   - **Delegates/DataSources**: Methods that respond to events
   - **Targets/Actions**: Button taps, gesture recognizers
   - **Observers**: NotificationCenter, KVO
   - **Timers/Async**: DispatchQueue, Timer
   - **Navigation**: Push/pop logic, modal presentation
   - **Configuration**: navigationItem, tabBarItem settings

**Remember**: The UIKit ViewControllers are kept during migration specifically so you can reference them when issues arise. Use them as your source of truth.

---

## Step 2: Add App and Empty SplashScreen

### "Fatal error: Unexpectedly found nil while unwrapping an Optional value" at `self.window!`
- **Cause**: AppDelegate trying to access window when SwiftUI manages it.
- **Solution**: Remove all `self.window` usage from `AppDelegate`. SwiftUI now handles the window. Search for `self.window` in `AppDelegate` and `SceneDelegate`, and comment out all window setup code (`self.window = ...`, `self.window!.rootViewController = ...`, `self.window!.makeKeyAndVisible()`).

### "Duplicate @main attribute" or "@UIApplicationMain and @main cannot coexist"
- **Cause**: Both the SwiftUI `App` struct and the `AppDelegate` have an entry point attribute.
- **Solution**: Remove the `@UIApplicationMain` or `@main` attribute from `AppDelegate`. Only the SwiftUI `App` struct should have the `@main` attribute.

### Black screen on launch
- Check that your `App.swift` file has the `@main` attribute.
- Verify that your `WindowGroup` contains views to display.
- Check `Info.plist` for a conflicting `UIApplicationSceneManifest`.
- Confirm that `AppDelegate` has NO `@UIApplicationMain` or `@main` attribute.

### Build errors about @main
- Ensure there is only one `@main` attribute in your entire project.
- Remove `@UIApplicationMain` or `@main` from `AppDelegate`.

---

## Step 3: Implement Data Migration & Loading Process

### Migration takes too long
- Run the migration on a background thread.
- Display progress updates to the user in the splash screen.
- Consider batching large migrations to reduce memory pressure.
- Test with a realistic amount of data.

### Migration fails
- Check that the Core Data model name is correct in your migration logic.
- Verify that the Core Data `.xcdatamodeld` file is included in the target.
- Ensure that your Swift Data models have schemas that match the Core Data attributes.
- Add detailed error logging to pinpoint the exact point of failure.

### Data appears duplicated after migration
- Verify that your migration completion flag is being set correctly and only after a successful migration.
- Ensure the migration logic only runs once.
- Consider adding data validation to check for duplicates post-migration.

### Memory issues with large datasets
- Migrate data in batches rather than all at once (e.g., 100 items at a time).
- Use an `autoreleasepool` for Core Data fetches within a loop to manage memory.
- Explicitly clear fetched objects from memory after they have been migrated.
- Profile memory usage with Instruments during migration.

---

## Step 5: Verify First Screen Appears After Splash

### Splash screen doesn't disappear
- Check that the `isDone` binding between your splash screen and `App` struct is working correctly.
- Verify that your initialization/migration process completes successfully.
- Look for any errors in the Xcode console that might indicate an issue.

### Black screen after splash
- Verify that your main screen view is correctly added to the view hierarchy (e.g., in the `ZStack`) after the splash screen is done.
- Check the conditional logic in your `App` struct that controls the transition.
- Ensure the state variable (`isSplashDone`) correctly changes to `true`.

### App crashes after splash
- Double-check your initialization code for any potential runtime errors.
- Review `AppDelegate` for any remaining code that might conflict with the SwiftUI lifecycle.
- Verify that all necessary modules are imported in your new SwiftUI views.
