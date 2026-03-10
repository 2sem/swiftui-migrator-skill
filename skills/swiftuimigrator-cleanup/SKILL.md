---
name: swiftuimigrator-cleanup
description: Use when the SwiftUI migration is already verified and the remaining work is deleting legacy UIKit files, removing old entry logic, and doing final cleanup safely.
---

# SwiftUI Migrator Cleanup

## Purpose

Remove legacy UIKit migration scaffolding only after the SwiftUI implementation is fully verified.

## When to Use

- All required screens and features are already migrated
- Cleanup is the only remaining stage
- The work now involves deleting UIKit files or old startup wiring

## Scope

- Preconditions and verification gates
- Safe cleanup order
- Legacy file and entry-logic removal
- Final validation and rollback guidance

## Verification

- The app still builds and runs after cleanup
- No required UIKit migration scaffolding remains
- Rollback guidance exists before destructive steps

## Exit Criteria

The project no longer depends on legacy UIKit migration scaffolding.
