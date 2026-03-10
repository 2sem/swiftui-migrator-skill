# SwiftUI Migrator

A Claude Code skill that guides incremental migration from UIKit to SwiftUI, screen by screen, while keeping your app functional throughout the process.

## Install

```bash
npx skills add 2sem/swiftui-migrator-skill
```

The installable skill lives in `skills/swiftuimigrator/`, which matches the repository layout expected by the Vercel `skills` CLI.

## Overview

This repository now uses an orchestrator-plus-subskills model. `swiftuimigrator` remains the main entry point, and it routes work to focused subskills for setup, startup migration, screens, AdMob, and cleanup. The key principle remains the same: **migrate incrementally, keeping UIKit and SwiftUI running in parallel until everything works**.

## Skill Model

- **`swiftuimigrator`**: Orchestrator that detects the current migration stage and routes to the right specialized skill
- **`swiftuimigrator-project-setup`**: Tuist updates, `App.swift`, `SplashScreen`, and entry-point transition
- **`swiftuimigrator-data-migration`**: Startup initialization, migration, loading flow, and splash progress
- **`swiftuimigrator-screens`**: Screen-by-screen conversion, navigation rewiring, and UIKit bridge patterns
- **`swiftuimigrator-admob`**: AdMob-specific migration after the core app is stable
- **`swiftuimigrator-cleanup`**: Final deletion of legacy UIKit scaffolding after verification

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

1. **Install the skill**:
   ```bash
   npx skills add 2sem/swiftui-migrator-skill
   ```

2. **Start with the orchestrator**:
   ```
   Use the swiftuimigrator skill to migrate my UIKit app to SwiftUI
   ```

3. **Provide context**: Let Claude know:
   - Which screen you're starting with
   - Your app's current structure
   - Any special features (ads, data persistence, etc.)

4. **Let the orchestrator route the work**:
   - project shell setup
   - startup/data migration
   - screen migration
   - AdMob
   - cleanup

## Project Structure

```text
swiftui-migrator-skill/
├── README.md
├── AGENTS.md
└── skills/
    ├── swiftuimigrator/
    │   ├── SKILL.md                  # Orchestrator
    │   ├── guides/                   # Shared references
    │   └── samples/                  # Shared samples
    ├── swiftuimigrator-project-setup/
    │   └── SKILL.md
    ├── swiftuimigrator-data-migration/
    │   └── SKILL.md
    ├── swiftuimigrator-screens/
    │   └── SKILL.md
    ├── swiftuimigrator-admob/
    │   └── SKILL.md
    └── swiftuimigrator-cleanup/
        └── SKILL.md
```

## When to Use Which Skill

- Start with `swiftuimigrator` unless you already know the exact migration stage.
- Use `swiftuimigrator-project-setup` for `App.swift`, `SplashScreen`, and Tuist shell work.
- Use `swiftuimigrator-data-migration` for startup loading, migration, and `AppInitializer` logic.
- Use `swiftuimigrator-screens` for repeated `ViewController` to `Screen` conversion work.
- Use `swiftuimigrator-admob` only after the core SwiftUI app is already stable.
- Use `swiftuimigrator-cleanup` only after the migration is fully verified.

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
- AdMob integration (see `skills/swiftuimigrator/guides/admob-migration.md`)
- Data persistence patterns
- Network layer adaptation
- Third-party SDK integration

## How It Works

The orchestrator keeps the public entry point stable, but hands stage-specific work to smaller skills. Shared guides and samples stay under `skills/swiftuimigrator/` so subskills can reference the same material without duplicating assets.

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
**Location**: `skills/swiftuimigrator/guides/admob-migration.md`
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

See `skills/swiftuimigrator/SKILL.md` for detailed troubleshooting, including:

- Project generation issues
- State management problems
- Navigation conflicts
- Performance optimization
- Common Xcode errors

## License

This skill is part of your Claude Code workspace and follows your project's licensing.

---

## Getting Help

1. Check `skills/swiftuimigrator/SKILL.md` for stage detection and routing
2. Review `skills/swiftuimigrator/guides/` for specialized feature migration
3. Examine `skills/swiftuimigrator/samples/` for reference implementations
4. Ask Claude Code for clarification on specific steps

**Ready to start?** Activate the skill and follow the 9-step workflow! 🚀
