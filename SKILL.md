# swiftuimigrator

**Description**: Guides step-by-step incremental migration from UIKit to SwiftUI. Helps convert ViewControllers to SwiftUI Views, migrate UIKit screens to SwiftUI screens, modernize iOS apps with SwiftUI, and transition from UIKit navigation to SwiftUI navigation patterns. Provides 9-step workflow for safe, incremental migration while keeping the app running.

**When to use**: When migrating UIKit app to SwiftUI, converting ViewControllers to Views, modernizing iOS app architecture, transitioning from UITableView to List, moving from UIKit to SwiftUI step by step, or refactoring legacy UIKit code to modern SwiftUI. Use when you need to migrate screens incrementally while keeping the app functional throughout the process.

**Prerequisites**:
- Existing UIKit project using Tuist
- Xcode 15+ with SwiftUI support
- Basic understanding of SwiftUI patterns

**Keywords**: UIKit migration, SwiftUI migration, ViewController to View, UIKit to SwiftUI, iOS modernization, SwiftUI refactoring, incremental migration, UITableView to List, UIButton to Button, screen migration, app migration, legacy code migration, Tuist SwiftUI

---

# SwiftUI Migration Workflow

This workflow guides the complete migration of a UIKit app to SwiftUI using a proven, incremental approach. The key principle: **keep all UIKit ViewControllers running until migration is complete**.

## Migration Strategy

The migration follows a battle-tested sequence that minimizes risk:

1. **Update Tuist for SwiftUI** - Enable SwiftUI in project configuration
2. **Add App and Empty SplashScreen** - Create SwiftUI entry point
3. **Implement Data Migration & Loading** - Move initialization to SplashScreen
4. **Create First Screen** - Migrate root ViewController to SwiftUI
5. **Verify First Screen** - Ensure it appears after splash
6. **Implement Features Incrementally** - Migrate features one by one
7. **Pick Next Screen** - Repeat steps 4-6 for each screen
8. **Migrate AdMob** - Add ads after all features work (see sub-guide)
9. **Keep All ViewControllers** - Don't delete UIKit code until done

## Paths
- **AdMob Sub-Guide**: .claude/skills/swiftuimigrator/guides/admob-migration.md
- **General Samples**: .claude/skills/swiftuimigrator/samples/general/
- **AdMob Samples**: .claude/skills/swiftuimigrator/samples/admob/

## Rules
- **Incremental Migration**: Migrate one screen at a time, verify it works before moving to the next
- **Keep UIKit Running**: Don't delete ViewControllers until the entire migration is complete
- **Avoid Duplication**: Check if code already exists before adding
- **Error Reporting**: Report issues with specific file:line references
- **Progress Tracking**: Use TodoWrite tool throughout migration
- **Verify After Each Step**: Build and run after completing each major step

---

## Step 1: Update Tuist for SwiftUI

### Purpose
Enable SwiftUI support in your Tuist project configuration.

### Tasks

1. **Open Project.swift**:
   - Location: `Projects/App/Project.swift`
   - This is your main Tuist configuration file

2. **Update Deployment Target**:
   - Purpose: SwiftUI requires iOS 14.0+
   - Find: `deploymentTarget: .iOS(targetVersion:`
   - Result: Deployment target is iOS 14.0 or higher
   ```swift
   deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone])
   ```

3. **Add SwiftUI Framework**:
   - Purpose: Link SwiftUI framework to your app target
   - Find the `dependencies` array in your app target
   - Add: `.sdk(name: "SwiftUI", type: .framework)`
   - Result: SwiftUI is available for import

4. **Regenerate Project**:
   ```bash
   mise x -- tuist generate --no-open
   ```

### Verification
- [ ] `Project.swift` has iOS 14.0+ deployment target
- [ ] SwiftUI framework is in dependencies
- [ ] Project regenerates without errors
- [ ] `import SwiftUI` compiles in a test file

---

## Step 2: Add App and Empty SplashScreen

### Purpose
Create the SwiftUI entry point with a splash screen that will handle app initialization.

### Tasks

1. **Create App.swift**:
   - **File Name**: Always use `App.swift` (NOT `{ProjectName}App.swift`)
   - **Location**: `Projects/App/Sources/App.swift`
   - **Purpose**: SwiftUI app entry point
   - **Struct Name**: Name after your project (e.g., if project is "MyApp", use `MyAppApp`)
   - Refer: `samples/general/App.swift`

   ```swift
   import SwiftUI

   @main
   struct MyAppApp: App {  // Replace "MyApp" with your project name
       @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
       @State private var isSplashDone = false

       var body: some Scene {
           WindowGroup {
               ZStack {
                   // Main content will go here
                   if !isSplashDone {
                       SplashScreen(isDone: $isSplashDone)
                           .transition(.opacity)
                   }
               }
           }
       }
   }
   ```
   
   **Important**: 
   - ✅ File name: `App.swift` (always the same)
   - ✅ Struct name: `MyAppApp` (replace "MyApp" with your project name)
   - ❌ Don't name file: `MyAppApp.swift`

2. **Create SplashScreen.swift**:
   - Location: `Projects/App/Sources/Screens/SplashScreen.swift`
   - Purpose: Loading screen for initialization
   - Refer: `samples/general/SplashScreen.swift` (to be created)

   ```swift
   import SwiftUI

   struct SplashScreen: View {
       @Binding var isDone: Bool

       var body: some View {
           ZStack {
               Color.blue // Your brand color
                   .ignoresSafeArea()

               VStack {
                   // Your logo or loading indicator
                   ProgressView()
                       .progressViewStyle(CircularProgressViewStyle(tint: .white))
                       .scaleEffect(2)
               }
           }
           .onAppear {
               // Will add initialization logic in Step 3
               DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   withAnimation {
                       isDone = true
                   }
               }
           }
       }
   }
   ```

3. **Keep AppDelegate BUT Remove @UIApplicationMain**:
   - **Important**: Do NOT delete your existing `AppDelegate.swift`
   - **Critical**: REMOVE `@UIApplicationMain` or `@main` from AppDelegate
   - Only the SwiftUI App struct should have `@main`
   
   ```swift
   // ❌ REMOVE @UIApplicationMain or @main
   // @UIApplicationMain  <- DELETE THIS LINE
   // @main               <- OR DELETE THIS LINE
   class AppDelegate: UIResponder, UIApplicationDelegate {
       var window: UIWindow?
       
       func application(_ application: UIApplication, 
                       didFinishLaunchingWithOptions...) -> Bool {
           return true
       }
   }
   ```
   
   - The `@UIApplicationDelegateAdaptor` in your App struct bridges to AppDelegate
   - AppDelegate still handles UIKit lifecycle methods during migration

4. **Clean Up AppDelegate Window Management**:
   - **Critical**: SwiftUI now manages the window, so `AppDelegate.window` is nil
   - **Remove or comment out** any window setup code in AppDelegate:
   
   ```swift
   class AppDelegate: UIResponder, UIApplicationDelegate {
       var window: UIWindow?  // Keep property but don't use it
       
       func application(_ application: UIApplication, 
                       didFinishLaunchingWithOptions...) -> Bool {
           // ❌ REMOVE - Causes crash with SwiftUI
           // self.window = UIWindow(frame: UIScreen.main.bounds)
           // self.window!.rootViewController = MainViewController()
           // self.window!.makeKeyAndVisible()
           
           // ✅ KEEP - Other initialization is fine
           setupDatabase()
           configureAnalytics()
           
           return true
       }
   }
   ```
   
   - If you have SceneDelegate, also remove window setup there
   - Keep all other initialization (database, analytics, etc.)

5. **Update Info.plist**:
   - Remove `UIApplicationSceneManifest` if it causes conflicts
   - Or keep it and add scene configuration in App.swift

5. **Regenerate and Build**:
   ```bash
   mise x -- tuist generate --no-open
   tuist build
   ```

### Troubleshooting

**Error: "Fatal error: Unexpectedly found nil while unwrapping an Optional value" at `self.window!`**
- **Cause**: AppDelegate trying to access window when SwiftUI manages it
- **Solution**: Remove all `self.window` usage from AppDelegate (see Step 4 above)
- **Check**: Search for `self.window` in AppDelegate and SceneDelegate, comment out all window setup

**Error: "Duplicate @main attribute" or "@UIApplicationMain and @main cannot coexist"**
- **Cause**: Both App.swift and AppDelegate have entry point attributes
- **Solution**: Remove `@UIApplicationMain` or `@main` from AppDelegate (see Step 3 above)
- **Keep**: Only `@main` on your SwiftUI App struct
- **Critical**: AppDelegate should have NO `@main` or `@UIApplicationMain`

**Black screen on launch:**
- Check that App.swift has `@main` attribute
- Verify WindowGroup contains your views
- Check Info.plist doesn't have conflicting UIApplicationSceneManifest
- Confirm AppDelegate has NO `@UIApplicationMain` or `@main`

**Build errors about @main:**
- Only one `@main` allowed - check you don't have multiple
- Remove `@UIApplicationMain` or `@main` from AppDelegate
- Keep only `@main` on SwiftUI App struct

### Verification
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

### Purpose
Move data initialization, migrations, and heavy loading operations into the SplashScreen so they complete before the main UI appears.

### Tasks

1. **Find Initialization Code**:
   - Check `AppDelegate.application(_:didFinishLaunchingWithOptions:)`
   - Check SceneDelegate if you have one
   - Look for: Database setup, Core Data migrations, UserDefaults initialization, API configuration

2. **Create Initialization Manager** (Optional but Recommended):
   - Location: `Projects/App/Sources/Managers/AppInitializer.swift`
   - Purpose: Centralize all initialization logic

   ```swift
   import Foundation

   class AppInitializer {
       static func initialize() async throws {
           // Database migrations
           try await migrateDatabaseIfNeeded()

           // UserDefaults setup
           setupUserDefaults()

           // API configuration
           configureNetworking()

           // Any other initialization
       }

       private static func migrateDatabaseIfNeeded() async throws {
           // Your migration logic (see Core Data → Swift Data section below)
       }

       private static func setupUserDefaults() {
           // UserDefaults initialization
       }

       private static func configureNetworking() {
           // API setup
       }
   }
   ```

**2.1 Core Data to Swift Data Migration** (If Applicable):

If your UIKit app used Core Data and you want to migrate to Swift Data (recommended for SwiftUI):

**Step A: Create Swift Data Models**
   
Location: `Projects/App/Sources/Models/`

```swift
import SwiftData

@Model
final class Item {
    var id: UUID
    var name: String
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}
```

**Step B: Set Up Swift Data in App.swift**

```swift
import SwiftUI
import SwiftData

@main
struct YourAppNameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isSplashDone = false
    
    // Swift Data model container
    var modelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            // Add all your @Model classes here
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashDone {
                    MainScreen()
                        .transition(.opacity)
                }
                
                if !isSplashDone {
                    SplashScreen(isDone: $isSplashDone)
                        .transition(.opacity)
                }
            }
        }
        .modelContainer(modelContainer)  // Make Swift Data available
    }
}
```

**Step C: Create Data Migration Manager**

Location: `Projects/App/Sources/Managers/DataMigrationManager.swift`

```swift
import Foundation
import CoreData
import SwiftData

class DataMigrationManager {
    
    /// Check if migration from Core Data to Swift Data is needed
    static func needsMigration() -> Bool {
        let key = "didMigrateToCoreDataToSwiftData"
        return !UserDefaults.standard.bool(forKey: key)
    }
    
    /// Mark migration as complete
    static func markMigrationComplete() {
        UserDefaults.standard.set(true, forKey: "didMigrateToCoreDataToSwiftData")
    }
    
    /// Perform migration from Core Data to Swift Data
    static func migrate(
        modelContainer: ModelContainer,
        progressCallback: @escaping (String, Double) -> Void
    ) async throws {
        guard needsMigration() else {
            progressCallback("Already migrated", 1.0)
            return
        }
        
        progressCallback("Starting migration...", 0.0)
        
        // 1. Load Core Data stack
        let coreDataStack = try loadCoreDataStack()
        let context = coreDataStack.viewContext
        
        // 2. Get Swift Data context
        let swiftDataContext = ModelContext(modelContainer)
        
        // 3. Fetch all entities from Core Data
        progressCallback("Loading data...", 0.2)
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Item")
        let coreDataItems = try context.fetch(fetchRequest)
        
        // 4. Migrate each item
        let total = Double(coreDataItems.count)
        for (index, coreDataItem) in coreDataItems.enumerated() {
            // Extract data from Core Data
            guard let id = coreDataItem.value(forKey: "id") as? UUID,
                  let name = coreDataItem.value(forKey: "name") as? String,
                  let createdAt = coreDataItem.value(forKey: "createdAt") as? Date else {
                continue
            }
            
            // Create Swift Data model
            let swiftDataItem = Item(id: id, name: name, createdAt: createdAt)
            swiftDataContext.insert(swiftDataItem)
            
            // Update progress
            let progress = 0.2 + (0.7 * Double(index + 1) / total)
            progressCallback("Migrating \(index + 1)/\(coreDataItems.count)...", progress)
        }
        
        // 5. Save Swift Data
        progressCallback("Saving...", 0.9)
        try swiftDataContext.save()
        
        // 6. Mark migration complete
        markMigrationComplete()
        progressCallback("Migration complete!", 1.0)
    }
    
    private static func loadCoreDataStack() throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "YourDataModelName")
        var loadError: Error?
        
        container.loadPersistentStores { description, error in
            if let error = error {
                loadError = error
            }
        }
        
        if let error = loadError {
            throw error
        }
        
        return container
    }
}
```

**Step D: Update AppInitializer to Use Migration**

```swift
class AppInitializer {
    static func initialize(
        modelContainer: ModelContainer,
        progressCallback: @escaping (String, Double) -> Void
    ) async throws {
        // Migrate Core Data to Swift Data if needed
        if DataMigrationManager.needsMigration() {
            try await DataMigrationManager.migrate(
                modelContainer: modelContainer,
                progressCallback: progressCallback
            )
        }
        
        // Other initialization
        setupUserDefaults()
        configureNetworking()
    }
    
    private static func setupUserDefaults() {
        // UserDefaults initialization
    }
    
    private static func configureNetworking() {
        // API setup
    }
}
```

3. **Update SplashScreen**:
   - Add initialization logic to `onAppear`
   - Handle errors gracefully
   - Show loading progress if needed

**Basic Version (No Data Migration):**

```swift
struct SplashScreen: View {
    @Binding var isDone: Bool
    @State private var loadingMessage = "Loading..."
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)

                Text(loadingMessage)
                    .foregroundColor(.white)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("Retry") {
                Task {
                    await performInitialization()
                }
            }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            Task {
                await performInitialization()
            }
        }
    }

    private func performInitialization() async {
        do {
            loadingMessage = "Initializing..."
            try await AppInitializer.initialize()

            loadingMessage = "Ready!"
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

            withAnimation {
                isDone = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
```

**Advanced Version (With Core Data → Swift Data Migration):**

```swift
struct SplashScreen: View {
    @Binding var isDone: Bool
    @Environment(\.modelContext) private var modelContext
    
    @State private var loadingMessage = "Loading..."
    @State private var progress: Double = 0.0
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .frame(width: 200)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)

                Text(loadingMessage)
                    .foregroundColor(.white)
                    .font(.headline)
                
                if progress > 0 && progress < 1 {
                    Text("\(Int(progress * 100))%")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
        .alert("Migration Error", isPresented: $showError) {
            Button("Retry") {
                Task {
                    await performInitialization()
                }
            }
            Button("Cancel", role: .cancel) {
                // Handle cancellation
            }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            Task {
                await performInitialization()
            }
        }
    }

    private func performInitialization() async {
        do {
            // Get model container from environment
            guard let modelContainer = modelContext.container else {
                throw NSError(domain: "Migration", code: -1, 
                            userInfo: [NSLocalizedDescriptionKey: "No model container"])
            }
            
            // Perform initialization with progress updates
            try await AppInitializer.initialize(
                modelContainer: modelContainer
            ) { message, progressValue in
                Task { @MainActor in
                    loadingMessage = message
                    progress = progressValue
                }
            }

            loadingMessage = "Ready!"
            progress = 1.0
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

            withAnimation {
                isDone = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
```

4. **Move Launch Count Increment** (If Applicable):
   - If you track launch counts, move it here
   - Example: `UserDefaults.standard.increaseLaunchCount()`

### Troubleshooting Data Migration

**Migration takes too long:**
- Run migration on background thread (already async)
- Show progress updates to user (see Advanced SplashScreen)
- Consider batching large migrations
- Test with realistic data size

**Migration fails:**
- Check Core Data model name is correct
- Verify Core Data .xcdatamodeld file exists
- Ensure Swift Data models match Core Data schema
- Add better error logging to identify specific failures

**Data appears duplicated:**
- Check `needsMigration()` flag is working
- Verify `markMigrationComplete()` is called
- Ensure migration only runs once
- Consider adding data validation

**Memory issues with large datasets:**
- Migrate in batches instead of all at once
- Use autoreleasepool for Core Data fetches
- Clear objects from memory after migration
- Monitor memory usage during testing

### Verification
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

### Purpose
Migrate your root ViewController (usually the first screen users see) to a SwiftUI View.

### Tasks

1. **Identify Root ViewController**:
   - Check AppDelegate or SceneDelegate
   - Usually: MainViewController, HomeViewController, or TabBarController
   - Example: `window.rootViewController = MainViewController()`

2. **Create SwiftUI Screen File**:
   - Location: `Projects/App/Sources/Screens/{Name}Screen.swift`
   - Naming: If ViewController is `MainViewController`, create `MainScreen`
   - Purpose: SwiftUI version of the ViewController
   
   **IMPORTANT - Do NOT create ContentView.swift:**
   - ❌ Don't create: `ContentView.swift` (Xcode template, not meaningful in migration)
   - ✅ Create: `MainScreen.swift` (or actual screen name from your ViewController)
   - ✅ Create: `HomeScreen.swift`, `SettingsScreen.swift`, etc. (based on actual screens)
   - ContentView is a placeholder - we're migrating real screens with real names

3. **Analyze ViewController Structure**:
   - What UI elements exist? (buttons, labels, table views, etc.)
   - What data does it display?
   - What actions does it perform?
   - What navigation does it trigger?

4. **Create Basic Screen Structure**:
   ```swift
   import SwiftUI

   struct MainScreen: View {
       // State properties will go here

       var body: some View {
           NavigationStack {
               VStack {
                   Text("Main Screen")
                       .font(.largeTitle)

                   // UI elements will go here
               }
               .navigationTitle("Home")
           }
       }
   }

   #Preview {
       MainScreen()
   }
   ```

5. **Update App.swift to Show New Screen**:
   ```swift
   @main
   struct YourAppNameApp: App {
       @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
       @State private var isSplashDone = false

       var body: some Scene {
           WindowGroup {
               ZStack {
                   // Main content
                   if isSplashDone {
                       MainScreen()
                           .transition(.opacity)
                   }

                   // Splash overlay
                   if !isSplashDone {
                       SplashScreen(isDone: $isSplashDone)
                           .transition(.opacity)
                   }
               }
           }
       }
   }
   ```

6. **Keep Original ViewController**:
   - **Do NOT delete** `MainViewController.swift`
   - You may need to reference it while implementing features
   - It will be removed in the final cleanup

### Verification
- [ ] SwiftUI screen file created with meaningful name (e.g., `MainScreen.swift`)
- [ ] **No `ContentView.swift` created** (template file, not needed)
- [ ] Basic structure compiles
- [ ] App.swift updated to show new screen
- [ ] Original ViewController still exists
- [ ] App builds successfully

---

## Step 5: Verify First Screen Appears After Splash

### Purpose
Ensure the transition from splash to main screen works correctly before adding features.

### Tasks

1. **Build and Run**:
   ```bash
   tuist build
   ```
   - Or: Run from Xcode (Cmd+R)

2. **Test Splash → Main Transition**:
   - [ ] App launches
   - [ ] Splash screen appears
   - [ ] Initialization completes
   - [ ] Splash screen fades out
   - [ ] Main screen fades in
   - [ ] No crashes or errors

3. **Check Xcode Console**:
   - Look for errors or warnings
   - Verify initialization logs
   - Check for memory warnings

4. **Test on Multiple Devices**:
   - Different screen sizes (SE, Pro, Pro Max)
   - Different iOS versions if supporting older versions

### Troubleshooting

**Splash doesn't disappear:**
- Check `isDone` binding is working
- Verify initialization completes
- Check for errors in console

**Black screen after splash:**
- Verify `MainScreen` is properly added to ZStack
- Check conditional logic in App.swift
- Ensure `isSplashDone` state changes to `true`

**Crashes:**
- Check initialization code for errors
- Review AppDelegate for conflicts
- Verify all imports are correct

### Verification
- [ ] Splash screen appears on launch
- [ ] Initialization completes without errors
- [ ] Main screen appears after splash
- [ ] Transition animation works smoothly
- [ ] No crashes or black screens

---

## Step 6: Implement Features in the First Screen One by One

### Purpose
Incrementally migrate each feature from the ViewController to the SwiftUI Screen, verifying after each addition.

### Strategy
Migrate features in this order:
1. Static UI elements (labels, images)
2. Basic interactions (buttons, taps)
3. Lists/Collections
4. Navigation
5. Data loading & display
6. Complex interactions
7. Third-party integrations (leave AdMob for Step 8)

### Common Migration Patterns

#### 6.1 UILabel → Text
```swift
// UIKit
let label = UILabel()
label.text = "Hello"
label.font = .systemFont(ofSize: 24, weight: .bold)
label.textColor = .blue

// SwiftUI
Text("Hello")
    .font(.system(size: 24, weight: .bold))
    .foregroundColor(.blue)
```

#### 6.2 UIButton → Button
```swift
// UIKit
let button = UIButton()
button.setTitle("Tap Me", for: .normal)
button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

@objc func didTapButton() {
    print("Tapped")
}

// SwiftUI
Button("Tap Me") {
    print("Tapped")
}
```

#### 6.3 UITableView → List
```swift
// UIKit
class MainViewController: UIViewController, UITableViewDataSource {
    let tableView = UITableView()
    let items = ["Item 1", "Item 2", "Item 3"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

// SwiftUI
struct MainScreen: View {
    let items = ["Item 1", "Item 2", "Item 3"]

    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
    }
}
```

#### 6.4 Navigation → NavigationLink
```swift
// UIKit
let nextVC = DetailViewController()
navigationController?.pushViewController(nextVC, animated: true)

// SwiftUI
NavigationLink("Go to Detail") {
    DetailScreen()
}
```

#### 6.5 Data Loading with @StateObject
```swift
// UIKit
class MainViewController: UIViewController {
    var data: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        NetworkService.fetchItems { [weak self] items in
            self?.data = items
            self?.tableView.reloadData()
        }
    }
}

// SwiftUI
@MainActor
class MainViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false

    func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            items = try await NetworkService.fetchItems()
        } catch {
            print("Error: \(error)")
        }
    }
}

struct MainScreen: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        List(viewModel.items) { item in
            Text(item.name)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
```

#### 6.6 UserDefaults → @AppStorage
```swift
// UIKit
UserDefaults.standard.set(true, forKey: "isDarkMode")
let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")

// SwiftUI
struct MainScreen: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        Toggle("Dark Mode", isOn: $isDarkMode)
    }
}
```

#### 6.7 Delegates → Closures/Combine
```swift
// UIKit with Delegate
protocol SettingsDelegate: AnyObject {
    func didUpdateSettings()
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsDelegate?

    @objc func didTapSave() {
        delegate?.didUpdateSettings()
    }
}

// SwiftUI with Closure
struct SettingsScreen: View {
    var onUpdate: () -> Void

    var body: some View {
        Button("Save") {
            onUpdate()
        }
    }
}

// Usage
SettingsScreen {
    print("Settings updated")
}
```

### Tasks for Each Feature

1. **Identify One Feature**:
   - Pick the simplest feature first
   - Example: A button that shows an alert

2. **Find UIKit Implementation**:
   - Read the ViewController code
   - Understand what it does
   - Note any dependencies

3. **Implement in SwiftUI**:
   - Use SwiftUI equivalents (see patterns above)
   - Add necessary state properties
   - Implement actions/bindings

4. **Test the Feature**:
   - Build and run
   - Verify feature works identically to UIKit
   - Check edge cases

5. **Repeat for Next Feature**:
   - Pick next feature
   - Go to step 2

### Using UIKit Views When Needed

If a UIKit view has no SwiftUI equivalent, use `UIViewRepresentable`:

```swift
struct CustomUIKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SomeUIKitView {
        return SomeUIKitView()
    }

    func updateUIView(_ uiView: SomeUIKitView, context: Context) {
        // Update view
    }
}
```

### Verification After Each Feature
- [ ] Feature implemented in SwiftUI
- [ ] Feature works identically to UIKit version
- [ ] No crashes or visual glitches
- [ ] State management works correctly
- [ ] Build succeeds

---

## Step 7: Pick Next Screen → Repeat Step 4-6

### Purpose
After completing one screen, move to the next screen and repeat the migration process.

### Tasks

1. **Choose Next Screen**:
   - Priority: Screens users access most frequently
   - Start with simple screens before complex ones
   - Consider navigation flow (migrate parent before child)

2. **Repeat Steps 4-6**:
   - **Step 4**: Create SwiftUI screen from ViewController
   - **Step 5**: Verify screen appears correctly
   - **Step 6**: Implement features one by one

3. **Handle Navigation Between Screens**:

   **A. Push Navigation**:
   ```swift
   // UIKit
   navigationController?.pushViewController(DetailVC(), animated: true)

   // SwiftUI
   NavigationLink("Go to Detail") {
       DetailScreen()
   }
   ```

   **B. Modal Presentation**:
   ```swift
   // UIKit
   present(SettingsVC(), animated: true)

   // SwiftUI
   @State private var showSettings = false

   Button("Settings") {
       showSettings = true
   }
   .sheet(isPresented: $showSettings) {
       SettingsScreen()
   }
   ```

   **C. Full Screen Cover**:
   ```swift
   .fullScreenCover(isPresented: $showOnboarding) {
       OnboardingScreen()
   }
   ```

4. **TabBar Screens**:
   If you have a TabBarController:

   ```swift
   struct MainTabView: View {
       var body: some View {
           TabView {
               HomeScreen()
                   .tabItem {
                       Label("Home", systemImage: "house")
                   }

               SearchScreen()
                   .tabItem {
                       Label("Search", systemImage: "magnifyingglass")
                   }

               SettingsScreen()
                   .tabItem {
                       Label("Settings", systemImage: "gear")
                   }
           }
       }
   }
   ```

5. **Track Migration Progress**:
   - Create a checklist of all screens
   - Mark each as: Not Started → In Progress → Complete
   - Use TodoWrite tool to track

### Screen Migration Checklist Template

Create a tracking document:
```
- [ ] MainScreen (Root)
  - [ ] UI Elements
  - [ ] Data Loading
  - [ ] Navigation

- [ ] DetailScreen
  - [ ] UI Elements
  - [ ] Data Loading
  - [ ] Actions

- [ ] SettingsScreen
  - [ ] UI Elements
  - [ ] UserDefaults
  - [ ] Actions

- [ ] ProfileScreen
  - [ ] UI Elements
  - [ ] Image Loading
  - [ ] Edit Flow
```

### Verification
- [ ] Next screen identified
- [ ] Screen migration completed following Steps 4-6
- [ ] Navigation to/from screen works
- [ ] All screens tracked in checklist
- [ ] No UIKit ViewControllers shown to users (but still in codebase)

---

## Step 8: Migrate AdMob After All Features Implemented

### Purpose
Add AdMob integration AFTER all screens and features are working. This ensures ads don't interfere with feature migration.

### When to Start
- ✅ All screens migrated to SwiftUI
- ✅ All features working correctly
- ✅ Navigation flows complete
- ✅ App is stable and tested

### Tasks

1. **Use AdMob Sub-Guide**:
   - Location: `.claude/skills/swiftuimigrator/guides/admob-migration.md`
   - Follow the detailed AdMob migration workflow
   - This includes:
     - UserDefaults setup for ad tracking
     - SwiftUIAdManager creation
     - Ad unit configuration
     - App initialization for ads
     - Per-screen ad integration

2. **Read AdMob Sub-Guide First**:
   ```bash
   # Path to guide
   .claude/skills/swiftuimigrator/guides/admob-migration.md
   ```

3. **Return Here After AdMob Migration**:
   - Complete Step 9 (Cleanup) after AdMob is working

### Verification
- [ ] AdMob sub-guide completed
- [ ] Interstitial ads working
- [ ] Opening ads working
- [ ] Launch count logic working
- [ ] No ad-related crashes

---

## Step 9: Keep All ViewControllers Until Migration Done

### Purpose
Maintain UIKit code throughout the migration as reference and fallback. Only remove it after everything works.

### During Migration (Steps 1-8)

**DO:**
- ✅ Keep all ViewController files in the project
- ✅ Keep UIKit storyboards/xibs
- ✅ Keep AppDelegate and SceneDelegate
- ✅ Reference UIKit code when implementing SwiftUI
- ✅ Use ViewController code as documentation

**DON'T:**
- ❌ Delete ViewController files
- ❌ Remove UIKit imports
- ❌ Delete delegation protocols
- ❌ Remove UIKit view classes
- ❌ Clean up "unused" code

### After Migration Complete (All Steps 1-8 Done)

Now you can clean up:

1. **Create a Backup Branch**:
   ```bash
   git checkout -b backup-uikit-code
   git push origin backup-uikit-code
   git checkout main
   ```

2. **Remove UIKit ViewControllers**:
   - Delete ViewController files that are now SwiftUI screens
   - Keep any UIKit utilities you still need
   - Remove storyboard references

3. **Clean Up AppDelegate**:
   - Remove SceneDelegate if no longer needed
   - Keep AppDelegate for system lifecycle events
   - Remove UIKit-specific initialization

4. **Update Project.swift**:
   - Remove UIKit frameworks if not needed
   - Update dependencies

5. **Final Verification**:
   - Build succeeds
   - All screens work
   - All features work
   - No crashes
   - Ads work (if applicable)

6. **Regenerate Project**:
   ```bash
   mise x -- tuist generate --no-open
   tuist build
   ```

### Verification
- [ ] Backup branch created with UIKit code
- [ ] UIKit files removed only after full migration
- [ ] App builds successfully after cleanup
- [ ] All features still work
- [ ] No references to deleted files

---

## Common Pitfalls

### During Migration

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
- **Problem**: You lose reference implementation
- **Solution**: Follow Step 9, keep everything until done

**Pitfall: Trying to migrate everything at once**
- **Problem**: Overwhelming, hard to debug
- **Solution**: Follow Steps 4-7, one screen at a time

**Pitfall: Skipping verification steps**
- **Problem**: Issues accumulate, hard to find root cause
- **Solution**: Build and test after each feature

**Pitfall: Mixing UIKit and SwiftUI navigation**
- **Problem**: Confusing navigation stack
- **Solution**: Use full SwiftUI navigation once a screen is migrated

### Project Structure

**Pitfall: Forgetting to regenerate after new files**
- **Problem**: "Cannot find in scope" errors
- **Solution**: Always run `tuist generate` after creating files

**Pitfall: Wrong deployment target**
- **Problem**: SwiftUI features not available
- **Solution**: Ensure iOS 14.0+ in Step 1

### State Management

**Pitfall: Not using @Published or @State**
- **Problem**: UI doesn't update
- **Solution**: Use proper property wrappers for reactive state

**Pitfall: Mutating state outside @MainActor**
- **Problem**: Purple runtime warnings, crashes
- **Solution**: Use `@MainActor` on classes, `Task { @MainActor in ... }`

### Performance

**Pitfall: Doing heavy work in body**
- **Problem**: Laggy UI, poor performance
- **Solution**: Use `.task`, `.onAppear`, or view models

**Pitfall: Creating new objects in body**
- **Problem**: Excessive memory usage
- **Solution**: Use `@StateObject`, `@ObservedObject`, or `let` constants

---

## Testing Strategy

### After Each Screen Migration
- [ ] Launch app from fresh install
- [ ] Navigate to the migrated screen
- [ ] Test all buttons and interactions
- [ ] Test data loading and display
- [ ] Test navigation to/from screen
- [ ] Test on multiple device sizes
- [ ] Test on iOS 14, 15, 16+ (if supporting)

### Before Completing Migration
- [ ] Full app walkthrough on device
- [ ] Test all user flows end-to-end
- [ ] Test with poor network conditions
- [ ] Test with empty data states
- [ ] Test with large data sets
- [ ] Memory profiling in Instruments
- [ ] Test on oldest supported iOS version

---

## Sub-Guides

### AdMob Migration
**When**: After all screens are migrated (Step 8)
**Location**: `.claude/skills/swiftuimigrator/guides/admob-migration.md`
**Purpose**: Add Google AdMob interstitial and opening ads to your SwiftUI app

---

## Completion Checklist

- [ ] Step 1: Tuist updated for SwiftUI
- [ ] Step 2: App and SplashScreen created
- [ ] Step 3: Data migration in SplashScreen
- [ ] Step 4-7: All screens migrated and verified
- [ ] Step 8: AdMob migrated (if applicable)
- [ ] Step 9: UIKit code cleaned up
- [ ] All features working identically to UIKit version
- [ ] App tested thoroughly on devices
- [ ] Performance is acceptable
- [ ] No crashes or memory issues
- [ ] App submitted/deployed successfully

**Congratulations! Your app is now fully SwiftUI! 🎉**
