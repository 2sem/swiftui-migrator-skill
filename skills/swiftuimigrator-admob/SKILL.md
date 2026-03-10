---
name: swiftuimigrator-admob
description: Use when the SwiftUI migration is already stable and the remaining work is Google AdMob integration, SwiftUIAdManager setup, ad-unit migration, or native ad UI migration.
---

# SwiftUI Migrator AdMob

## Overview

Use this skill only after project setup, startup flow, and core screen migration are already stable.

Core principle: AdMob is a late-stage migration concern. Do not introduce ad complexity while the app shell or screen parity is still unstable.

## When to Use

- Core setup and screen migration are already working
- The remaining migration work is specific to Google AdMob
- AdMob defaults, managers, or native ad views need SwiftUI equivalents

## Preconditions

- The app already has a stable SwiftUI entry path
- Startup logic is already migrated or stable
- Core screen migration is working without ad-related blockers

## Scope

- AdMob defaults and ad-unit setup
- `SwiftUIAdManager`
- App integration and lifecycle wiring
- Native ad migration
- Cleanup of legacy AdMob logic in `AppDelegate`

## Migration Tasks

### 1. Migrate AdMob configuration

1. Ensure the required defaults keys exist.
2. Migrate ad-unit naming and configuration into SwiftUI-compatible structures.

### 2. Add SwiftUI ad management

1. Create or adapt `SwiftUIAdManager`.
2. Move lifecycle-driven ad behavior out of legacy UIKit-only wiring.

### 3. Migrate screen-level ad UI

1. Add native ad support where needed.
2. Keep ad presentation logic explicit and testable.

### 4. Clean up legacy ad wiring

1. Remove obsolete AdMob logic from `AppDelegate` only after the SwiftUI flow is verified.

## Shared References

- AdMob guide: `../swiftuimigrator/guides/admob-migration.md`
- Verification: `../swiftuimigrator/guides/verification-checklists.md`

## Verification

- The app builds with AdMob integrated
- Ads only appear under the intended conditions
- Native ad views render correctly
- Legacy ad logic can be removed without regression

## Exit Criteria

AdMob works in the SwiftUI app without depending on legacy UIKit-specific ad wiring.
