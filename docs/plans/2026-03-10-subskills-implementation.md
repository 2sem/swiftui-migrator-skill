# SwiftUI Migrator Subskills Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Split `swiftuimigrator` into an orchestrator plus focused subskills for setup, data migration, screens, AdMob, and cleanup.

**Architecture:** Keep `skills/swiftuimigrator/SKILL.md` as the public orchestrator, create sibling skill directories for each major stage, and leave shared guides/samples under `skills/swiftuimigrator/` for the first pass.

**Tech Stack:** Markdown skill files, repository docs, git

---

### Task 1: Create subskill skeletons

**Files:**
- Create: `skills/swiftuimigrator-project-setup/SKILL.md`
- Create: `skills/swiftuimigrator-data-migration/SKILL.md`
- Create: `skills/swiftuimigrator-screens/SKILL.md`
- Create: `skills/swiftuimigrator-admob/SKILL.md`
- Create: `skills/swiftuimigrator-cleanup/SKILL.md`

### Task 2: Refactor the orchestrator

**Files:**
- Modify: `skills/swiftuimigrator/SKILL.md`

### Task 3: Fill setup and data migration subskills

**Files:**
- Modify: `skills/swiftuimigrator-project-setup/SKILL.md`
- Modify: `skills/swiftuimigrator-data-migration/SKILL.md`

### Task 4: Fill screens, admob, and cleanup subskills

**Files:**
- Modify: `skills/swiftuimigrator-screens/SKILL.md`
- Modify: `skills/swiftuimigrator-admob/SKILL.md`
- Modify: `skills/swiftuimigrator-cleanup/SKILL.md`

### Task 5: Update repository docs

**Files:**
- Modify: `README.md`
- Modify: `AGENTS.md`

### Task 6: Final verification

**Files:**
- Verify: all `skills/*/SKILL.md`
- Verify: `README.md`
- Verify: `AGENTS.md`
