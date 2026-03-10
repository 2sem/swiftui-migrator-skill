# Repository Guidelines

## Project Structure & Module Organization
This repository is a documentation-first skill suite for incremental UIKit to SwiftUI migration. `skills/swiftuimigrator/` is the orchestrator skill. Stage-specific execution lives in sibling skill directories such as `skills/swiftuimigrator-project-setup/`, `skills/swiftuimigrator-data-migration/`, `skills/swiftuimigrator-screens/`, `skills/swiftuimigrator-admob/`, and `skills/swiftuimigrator-cleanup/`. Contributor-facing overview and install instructions live in `README.md`. Shared reference material remains under `skills/swiftuimigrator/guides/`, and shared Swift sample code remains under `skills/swiftuimigrator/samples/`.

- `skills/swiftuimigrator/guides/samples/step*/` for step-specific migration examples
- `skills/swiftuimigrator/samples/general/` for reusable SwiftUI migration patterns
- `skills/swiftuimigrator/samples/admob/` for AdMob-specific integration samples

Prefer editing the smallest applicable subskill. Keep shared guides and samples under the orchestrator skill unless duplication is clearly justified.

## Build, Test, and Development Commands
There is no root build target for this repository itself; contributors mainly edit Markdown and Swift reference files. Use these commands to validate content and examples:

- `rg --files` lists repository files quickly when locating related docs or samples.
- `git diff --stat` reviews the scope of your changes before opening a PR.
- `mise x -- tuist generate --no-open` regenerates a sample Tuist project when following or validating the documented migration flow.
- `tuist build` verifies the generated sample project builds cleanly.

Run the `tuist` commands from a migrated app or sample project context, not from the repository root unless you add a local project for verification.

## Coding Style & Naming Conventions
Use concise, instructional Markdown with short sections and explicit file paths. Prefer sentence-case bullets and fenced code blocks for commands. In Swift samples, follow existing conventions: `UpperCamelCase` for types, descriptive screen names such as `MainScreen.swift` or `SplashScreen.swift`, and avoid generic names like `ContentView.swift`. Match the surrounding file’s style and keep examples production-oriented.

## Testing Guidelines
This repo relies on documentation accuracy and sample verification rather than an automated test suite. When changing workflow steps or samples, update the related checklist in `skills/swiftuimigrator/guides/verification-checklists.md`. Build any affected sample or target app with `tuist build`, and verify the documented flow still matches the code and screenshots you describe.

## Commit & Pull Request Guidelines
Recent history follows conventional prefixes such as `feat:`, `fix:`, and `update:`. Keep commit subjects short and imperative, for example `fix: correct splash screen path`. PRs should include a brief summary, the docs or samples touched, any related issue, and notes on how you verified the change. Include screenshots only when the change affects UI guidance or visual migration examples.
