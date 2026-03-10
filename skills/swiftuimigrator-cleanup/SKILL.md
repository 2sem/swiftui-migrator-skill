---
name: swiftuimigrator-cleanup
description: Use when the SwiftUI migration is already verified and the remaining work is deleting legacy UIKit files, removing old entry logic, and doing final cleanup safely.
---

# SwiftUI Migrator Cleanup

## Overview

Use this skill only after the SwiftUI migration is already verified end to end.

Core principle: cleanup is destructive. Make it explicit, reversible, and late.

## When to Use

- All required screens and features are already migrated
- Cleanup is the only remaining stage
- The remaining work is deleting UIKit files or old startup wiring

## Preconditions

- Setup, startup migration, and screen migration are complete
- AdMob migration is either complete or not needed
- The SwiftUI app already passes full functional verification

## Scope

- Verification gates before deletion
- Safe cleanup order
- Removal of legacy UIKit migration scaffolding
- Final validation and rollback advice

## Safe Cleanup Order

1. Create a backup branch before destructive edits.
2. Delete migrated `ViewController` files and storyboards only after their SwiftUI replacements are verified.
3. Remove remaining UIKit-specific entry logic.
4. Rebuild and perform a final app walkthrough.

## Rollback Advice

- Keep a backup branch before deleting legacy files.
- Prefer deleting in small batches instead of removing every UIKit artifact at once.
- If verification fails, restore the smallest possible deleted set and re-check assumptions.

## Shared References

- Verification: `../swiftuimigrator/guides/verification-checklists.md`

## Verification

- The app still builds after cleanup
- No required UIKit migration scaffolding remains
- The final SwiftUI flow works end to end

## Exit Criteria

The project no longer depends on legacy UIKit migration scaffolding.
