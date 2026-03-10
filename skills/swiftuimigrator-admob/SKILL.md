---
name: swiftuimigrator-admob
description: Use when the SwiftUI migration is already stable and the remaining work is Google AdMob integration, SwiftUIAdManager setup, ad-unit migration, or native ad UI migration.
---

# SwiftUI Migrator AdMob

## Purpose

Migrate AdMob integration after the rest of the SwiftUI migration is already working.

## When to Use

- Core app setup and screen migration are already stable
- The remaining migration work is specific to Google AdMob
- AdMob defaults, managers, or native ad views need SwiftUI equivalents

## Scope

- AdMob defaults and ad unit setup
- `SwiftUIAdManager`
- App integration and lifecycle wiring
- Native ad migration
- Legacy AdMob cleanup in `AppDelegate`

## Verification

- The app builds with AdMob integrated
- Ads show only under the intended conditions
- Legacy ad code can be safely removed after verification

## Exit Criteria

AdMob behavior works in the SwiftUI app without depending on legacy UIKit ad wiring.
