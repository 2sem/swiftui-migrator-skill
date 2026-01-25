# SwiftUI Migrator

A Claude Code skill that guides incremental migration from UIKit to SwiftUI, screen by screen, while keeping your app functional throughout the process.

## Overview

This skill provides a battle-tested, 9-step workflow for migrating existing UIKit apps to SwiftUI. The key principle: **migrate incrementally, keeping UIKit and SwiftUI running in parallel until everything works**.

## What It Does

- **Guides Full Migration**: Complete UIKit → SwiftUI migration workflow
- **Screen-by-Screen**: Incremental approach, one screen at a time
- **Keeps UIKit Running**: Maintains ViewControllers during migration
- **Includes Sub-Guides**: Specialized guides (AdMob, etc.) for specific features
- **Sample Code**: Reference implementations for common patterns
- **Verification Steps**: Built-in checkpoints after each step

## Migration Workflow (9 Steps)

1. **Update Tuist for SwiftUI** - Enable SwiftUI in project configuration
2. **Add App and Splash Screen** - Create SwiftUI entry point
3. **Implement Data Migration** - Move initialization logic to Splash
4. **Create First Screen** - Migrate root ViewController
5. **Verify First Screen** - Ensure transition works
6. **Implement Features** - Migrate features one by one
7. **Pick Next Screen** - Repeat steps 4-6 for each screen
8. **Migrate AdMob** - Add ads after all features work *(see sub-guide)*
9. **Keep ViewControllers** - Don't delete UIKit code until done

## Prerequisites

- Existing UIKit project using Tuist
- Xcode 15+ with SwiftUI support
- Basic understanding of SwiftUI patterns

## Quick Start

1. **Activate the skill** in Claude Code:
   ```
   Use the swiftuimigrator skill to migrate my UIKit app to SwiftUI
   ```

2. **Provide context**: Let Claude know:
   - Which screen you're starting with
   - Your app's current structure
   - Any special features (ads, data persistence, etc.)

3. **Follow the workflow**: The skill guides you through each step with:
   - Clear tasks and verification checkpoints
   - Code samples for common patterns
   - Troubleshooting for common pitfalls

## Project Structure

```
.claude/skills/swiftuimigrator/
├── README.md                          # This file
├── SKILL.md                           # Main 9-step workflow
├── guides/
│   ├── admob-migration.md            # AdMob-specific sub-guide
│   └── samples/                      # Step-specific examples
│       ├── step2-app-splash/         # Step 2: App entry point
│       ├── step3-data-migration/     # Step 3: Data migration
│       └── step4-first-screen/       # Step 4: First SwiftUI screen
└── samples/
    ├── general/                       # General SwiftUI patterns
    │   ├── App.swift                 # SwiftUI app entry point
    │   ├── SplashScreen.swift        # Loading screen example
    │   ├── MainScreen.swift          # Migrated screen example
    │   └── DataMigrationManager.swift # Core Data → Swift Data migration
    └── admob/                         # AdMob-specific samples
        ├── App.swift                 # App with AdMob initialization
        ├── SwiftUIAdManager.swift    # Ad manager for SwiftUI
        ├── GADUnitName.swift         # Type-safe ad units
        ├── LSDefaults.swift          # UserDefaults wrapper
        └── MigratedScreen.swift      # Screen with ad integration
```

## Key Features

### Incremental Migration
Migrate one screen at a time while keeping the app functional. No big-bang rewrites.

### Parallel Operation
UIKit and SwiftUI run side-by-side during migration. ViewControllers stay until the end.

### Common Patterns Covered
- UILabel → Text
- UIButton → Button
- UITableView → List
- Navigation patterns
- Data loading with @StateObject
- UserDefaults with @AppStorage
- Delegates → Closures/Combine
- **Core Data → Swift Data migration** (with progress tracking)

### Sub-Guides for Specialized Features
- **AdMob Migration**: Detailed guide for adding Google AdMob ads (Step 8)
- More sub-guides can be added as needed

### Sample Code Included
All samples demonstrate:
- Clean, readable SwiftUI code (Paul Hudson/Antoine van der Lee style)
- Proper state management
- Async/await patterns
- Error handling

**Note**: UserDefaults wrapper samples use `LSDefaults` as an example. Replace with your project's actual class name (e.g., `AppDefaults`, `UserDefaults`, etc.).

## Common Use Cases

### General Migration
- Migrating any UIKit app to SwiftUI
- Converting ViewControllers to SwiftUI Views
- Updating navigation patterns
- Modernizing state management

### Feature-Specific Migration
- AdMob integration (see `guides/admob-migration.md`)
- Data persistence patterns
- Network layer adaptation
- Third-party SDK integration

## How It Works

The skill provides step-by-step guidance:

1. **Analyzes your UIKit code** - Understands current structure
2. **Plans migration approach** - Identifies screens and dependencies
3. **Generates SwiftUI equivalents** - Creates Views from ViewControllers
4. **Provides verification steps** - Ensures each step works before moving on
5. **Handles edge cases** - UIViewRepresentable when needed
6. **Guides cleanup** - Removes UIKit code only after completion

## Verification Strategy

### After Each Screen
- [ ] Screen compiles without errors
- [ ] Features work identically to UIKit
- [ ] Navigation flows correctly
- [ ] No crashes or visual glitches

### Before Cleanup
- [ ] All screens migrated
- [ ] All features working
- [ ] Full app walkthrough successful
- [ ] Performance acceptable

## Sub-Guides

### AdMob Migration
**Location**: `guides/admob-migration.md`
**When to use**: Step 8, after all screens/features are migrated
**What it covers**:
- UserDefaults setup for ad tracking
- SwiftUIAdManager creation
- Ad unit configuration
- Interstitial and opening ads
- Launch count logic

## Common Pitfalls

### ❌ Don't Do This
- Delete UIKit code before migration is complete
- Try to migrate everything at once
- Skip verification steps
- Mix UIKit and SwiftUI navigation randomly

### ✅ Do This
- Migrate one screen at a time
- Keep all ViewControllers until the end
- Build and test after each feature
- Use full SwiftUI navigation once screen is migrated

## Testing Strategy

### During Migration
- Test each migrated screen thoroughly
- Verify navigation between screens
- Check data persistence
- Test on multiple device sizes

### Before Release
- Full app walkthrough
- Test on oldest supported iOS version
- Memory profiling
- Network condition testing
- Empty/large data state testing

## Best Practices

Following Paul Hudson and Antoine van der Lee's approaches:

- **Clean, readable SwiftUI code** - Clear structure, obvious intent
- **Proper separation of concerns** - ViewModels for complex logic
- **Type safety** - Enums over strings, strong typing
- **Reactive state management** - @Published, @State, @Binding
- **Modern concurrency** - async/await over completion handlers
- **Incremental approach** - Small, verifiable steps

## Contributing

This skill is designed to be extended:

- Add new sub-guides for specialized features
- Contribute sample implementations
- Improve existing patterns
- Document edge cases and solutions

## Troubleshooting

See `SKILL.md` for detailed troubleshooting, including:

- Project generation issues
- State management problems
- Navigation conflicts
- Performance optimization
- Common Xcode errors

## License

This skill is part of your Claude Code workspace and follows your project's licensing.

---

## Getting Help

1. Check `SKILL.md` for detailed step-by-step instructions
2. Review `guides/` for specialized feature migration
3. Examine `samples/` for reference implementations
4. Ask Claude Code for clarification on specific steps

**Ready to start?** Activate the skill and follow the 9-step workflow! 🚀
