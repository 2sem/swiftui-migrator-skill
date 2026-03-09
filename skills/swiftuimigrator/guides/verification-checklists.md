# SwiftUI Migration Verification Checklists

This document provides checklists to verify the successful completion of each step in the SwiftUI migration workflow.

## Step 1: Update Tuist for SwiftUI
- [ ] `Project.swift` has iOS 14.0+ deployment target
- [ ] SwiftUI framework is in dependencies
- [ ] Project regenerates without errors
- [ ] `import SwiftUI` compiles in a test file

---

## Step 2: Add App and Empty SplashScreen
- [ ] File named `App.swift` (NOT `MyAppApp.swift` or `{ProjectName}App.swift`)
- [ ] App.swift exists and compiles with `@main`
- [ ] Struct inside named after project (e.g., `MyAppApp` where "MyApp" is your project name)
- [ ] SplashScreen.swift exists and compiles
- [ ] **No `ContentView.swift` created** (not needed during migration)
- [ ] AppDelegate is NOT deleted
- [ ] **AppDelegate has NO `@UIApplicationMain` or `@main` attribute**
- [ ] **AppDelegate has NO `self.window` usage**
- [ ] App builds successfully (no duplicate @main errors)
- [ ] App launches showing splash screen (no crashes)
- [ ] Splash screen disappears after delay

---

## Step 3: Implement Data Migration & Loading Process
- [ ] All initialization logic identified
- [ ] AppInitializer (or equivalent) created
- [ ] SplashScreen calls initialization
- [ ] Error handling is in place
- [ ] App completes initialization before showing main UI
- [ ] No crashes during initialization
- [ ] **If migrating data: Migration completes successfully**
- [ ] **If migrating data: Data appears in app after migration**
- [ ] **If migrating data: Migration doesn't run on subsequent launches**

---

## Step 4: Create First Screen from Root ViewController
- [ ] SwiftUI screen file created with meaningful name (e.g., `MainScreen.swift`)
- [ ] **No `ContentView.swift` created** (template file, not needed)
- [ ] Basic structure compiles
- [ ] App.swift updated to show new screen
- [ ] Original ViewController still exists
- [ ] App builds successfully

---

## Step 5: Verify First Screen Appears After Splash
- [ ] Splash screen appears on launch
- [ ] Initialization completes without errors
- [ ] Main screen appears after splash
- [ ] Transition animation works smoothly
- [ ] No crashes or black screens

---

## Step 6: Implement Features in the First Screen One by One
- [ ] Feature implemented in SwiftUI
- [ ] Feature works identically to UIKit version
- [ ] No crashes or visual glitches
- [ ] State management works correctly
- [ ] Build succeeds

---

## Step 7: Pick Next Screen → Repeat Step 4-6
- [ ] Next screen identified
- [ ] Screen migration completed following Steps 4-6
- [ ] Navigation to/from screen works
- [ ] All screens tracked in checklist
- [ ] No UIKit ViewControllers shown to users (but still in codebase)

---

## Step 8: Migrate AdMob After All Features Implemented
- [ ] AdMob sub-guide completed
- [ ] Interstitial ads working
- [ ] Opening ads working
- [ ] Launch count logic working
- [ ] No ad-related crashes

---

## Step 9: Keep All ViewControllers Until Migration Done
- [ ] Backup branch created with UIKit code
- [ ] UIKit files removed only after full migration
- [ ] App builds successfully after cleanup
- [ ] All features still work
- [ ] No references to deleted files
