# SwiftUI Migrator Subskills Design

**Goal:** Split `swiftuimigrator` into a small orchestrator plus focused subskills without breaking the single public entry point.

## Target Skill Tree

```text
skills/
├── swiftuimigrator/
├── swiftuimigrator-project-setup/
├── swiftuimigrator-data-migration/
├── swiftuimigrator-screens/
├── swiftuimigrator-admob/
└── swiftuimigrator-cleanup/
```

## Responsibilities

- `swiftuimigrator`: orchestration, stage detection, routing, and global safety rules
- `swiftuimigrator-project-setup`: Tuist updates, `App.swift`, `SplashScreen`, entry-point transition
- `swiftuimigrator-data-migration`: startup initialization, migration flow, splash progress
- `swiftuimigrator-screens`: repeated screen-by-screen UIKit-to-SwiftUI conversion
- `swiftuimigrator-admob`: AdMob migration after the core app is stable
- `swiftuimigrator-cleanup`: final destructive cleanup after verification

## Shared Assets

Keep guides and samples under `skills/swiftuimigrator/` for the first pass. New subskills should reference shared materials rather than duplicating them.

## Acceptance Criteria

- The top-level skill becomes an orchestrator instead of a monolithic execution guide.
- Each subskill has a clear, non-overlapping scope.
- Shared guides and samples stay reusable.
- Migration order and safety rules remain explicit.
