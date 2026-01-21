# Project Overview

## Purpose
`swiftuimigrator` is a Claude Code skill that guides incremental migration from UIKit to SwiftUI using a battle-tested, 9-step workflow. It provides:
- Complete UIKit → SwiftUI migration strategy
- Screen-by-screen incremental approach
- Parallel UIKit/SwiftUI operation during migration
- Specialized sub-guides for specific features (AdMob, etc.)
- Sample code demonstrating common patterns

## Migration Workflow (9 Steps)
1. Update Tuist for SwiftUI
2. Add App and empty SplashScreen
3. Implement data migration and move loading process in SplashScreen
4. Create first Screen from Root view controller
5. Verify first screen appears after splash screen
6. Implement features in the first screen one by one
7. Pick next screen, repeat steps 4-6
8. Migrate AdMob after all features implemented (see sub-guide)
9. Keep all view controllers until migration is complete

## Tech Stack
- **Type**: Claude Code Skill (documentation + samples)
- **Language**: Swift (sample code only)
- **Documentation**: Markdown (SKILL.md, README.md, guides/*.md)
- **Dependencies**: 
  - Tuist (for project generation)
  - SwiftUI (iOS 14.0+)
  - GADManager 1.3.8+ (for AdMob sub-guide)

## Key Components
1. **SKILL.md**: Main 9-step migration workflow with detailed instructions
   - Includes flexible UserDefaults wrapper discovery (supports *Defaults.swift naming patterns)
   - Common migration patterns (UILabel→Text, UITableView→List, etc.)
   - Verification steps after each stage
   
2. **guides/admob-migration.md**: AdMob-specific sub-guide for Step 8
   - UserDefaults setup for ad tracking
   - SwiftUIAdManager creation
   - Ad unit configuration
   - Interstitial and opening ads implementation
   
3. **samples/general/**: General SwiftUI migration samples
   - `App.swift`: SwiftUI app entry point
   - `SplashScreen.swift`: Loading screen with initialization
   - `MainScreen.swift`: Example migrated screen with common patterns
   - `DataMigrationManager.swift`: Core Data → Swift Data migration with progress tracking
   
4. **samples/admob/**: AdMob-specific samples
   - `App.swift`: App with AdMob initialization
   - `SwiftUIAdManager.swift`: Observable ad manager class
   - `GADUnitName.swift`: Type-safe ad unit enum
   - `LSDefaults.swift`: UserDefaults wrapper
   - `MigratedScreen.swift`: Screen with ad integration

5. **README.md**: User-facing documentation and quick start guide

## Target Users
Developers migrating existing UIKit iOS apps to SwiftUI using Tuist, particularly those following an incremental migration strategy.

## Key Principle
**Keep UIKit and SwiftUI running in parallel. Don't delete ViewControllers until the entire migration is complete.**
