# Project Structure

## Directory Layout
```
swiftuimigrator/
├── README.md                           # User-facing documentation
├── SKILL.md                            # Main 9-step migration workflow
├── .gitignore                          # Git ignore rules
├── guides/                             # Sub-guides for specialized features
│   ├── admob-migration.md             # AdMob migration guide (Step 8)
│   └── samples/                       # Step-specific example implementations
│       ├── step2-app-splash/          # Step 2 examples
│       │   ├── App.swift              # Basic App entry point
│       │   └── SplashScreen.swift     # Basic splash with .task
│       ├── step3-data-migration/      # Step 3 examples
│       │   ├── DataMigrationManager.swift      # Full migration manager
│       │   ├── AppInitializer.swift            # Centralized initialization
│       │   └── SplashScreenWithMigration.swift # Splash with progress
│       └── step4-first-screen/        # Step 4 examples
│           └── MainScreen.swift       # Comprehensive screen example
└── samples/                            # Reference Swift implementations
    ├── general/                        # General SwiftUI migration samples
    │   ├── App.swift                  # SwiftUI app entry point
    │   ├── SplashScreen.swift         # Loading screen with initialization
    │   └── MainScreen.swift           # Example migrated screen
    └── admob/                          # AdMob-specific samples
        ├── App.swift                  # App with AdMob initialization
        ├── SwiftUIAdManager.swift     # Observable ad manager
        ├── GADUnitName.swift          # Type-safe ad units
        ├── LSDefaults.swift           # UserDefaults wrapper
        └── MigratedScreen.swift       # Screen with ads
```

## File Purposes

### Documentation Files

**README.md**: Quick start guide and overview
- Migration workflow summary
- Project structure
- Key features and patterns
- Common use cases
- Troubleshooting overview

**SKILL.md**: Detailed 9-step migration workflow
- Step-by-step instructions for Claude
- Verification checkpoints after each step
- Common migration patterns (UIKit → SwiftUI)
- Troubleshooting and pitfalls
- Testing strategy

**guides/admob-migration.md**: AdMob-specific sub-guide
- UserDefaults setup for ad tracking
- SwiftUIAdManager implementation
- Ad unit configuration
- App initialization for ads
- Per-screen ad integration
- Originally the old SKILL.md content

### Step-Specific Sample Files (guides/samples/)

Progressive examples for each workflow step:

**Step 2 (guides/samples/step2-app-splash/)**:
- App.swift - Minimal App entry point with splash
- SplashScreen.swift - Basic splash using .task for initialization

**Step 3 (guides/samples/step3-data-migration/)**:
- DataMigrationManager.swift - Full Core Data → Swift Data migration
- AppInitializer.swift - Centralized initialization manager
- SplashScreenWithMigration.swift - Splash with progress tracking

**Step 4 (guides/samples/step4-first-screen/)**:
- MainScreen.swift - Comprehensive example with all common patterns

### Sample Files (samples/general/)

General SwiftUI migration patterns (standalone reference files):

1. **App.swift**
   - SwiftUI @main entry point
   - UIApplicationDelegateAdaptor for AppDelegate bridge
   - Splash screen integration
   - State management for app lifecycle

2. **SplashScreen.swift**
   - Loading screen with initialization
   - Async data migration
   - Error handling with alerts
   - Progress indicators

3. **MainScreen.swift**
   - Example migrated screen from ViewController
   - Common SwiftUI patterns (List, NavigationStack)
   - State management (@State, @StateObject)
   - Navigation (NavigationLink, sheets)
   - Data loading patterns

4. **DataMigrationManager.swift**
   - Core Data to Swift Data migration
   - Progress tracking and callbacks
   - Batch processing for large datasets
   - Migration completion tracking
   - Example Swift Data models

### Sample Files (samples/admob/)

AdMob-specific implementations (referenced from guides/admob-migration.md):

1. **SwiftUIAdManager.swift**
   - Observable object for SwiftUI
   - Wraps GADManager for async/await
   - Implements GADManagerDelegate
   - Singleton pattern for compatibility

2. **App.swift**
   - AdMob SDK initialization
   - Scene phase handling
   - Opening ad on app active
   - Environment object injection

3. **GADUnitName.swift**
   - Type-safe enum for ad units
   - Maps to AdMob unit IDs
   - Test unit configuration

4. **LSDefaults.swift**
   - UserDefaults wrapper (example name)
   - Launch count tracking
   - Ad timing persistence
   - Tracking permission state

5. **MigratedScreen.swift**
   - Example screen with ads
   - presentFullAdThen pattern
   - EnvironmentObject usage
   - Launch count gating

## Integration Points

The skill guides users to integrate these samples into their Tuist-managed projects at:
- `Projects/App/Project.swift` (configuration)
- `Projects/App/Sources/App.swift` (app entry point)
- `Projects/App/Sources/Screens/` (SwiftUI screens)
- `Projects/App/Sources/Managers/` (managers like SwiftUIAdManager)
- `Projects/App/Sources/Extensions/Ad/` (ad-related extensions)
- `Projects/App/Sources/Data/` (data models and defaults)

## Migration Flow

1. Users start with SKILL.md (main workflow)
2. Follow Steps 1-7 using samples/general/ as reference
3. At Step 8, switch to guides/admob-migration.md if needed
4. Use samples/admob/ for AdMob implementation
5. Return to SKILL.md for Step 9 (cleanup)
