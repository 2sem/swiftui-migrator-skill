# Repository Guidelines

## Project Structure & Module Organization
This repository is a documentation-first skill for incremental UIKit to SwiftUI migration. The main workflow lives in `SKILL.md`. Contributor-facing overview and examples live in `README.md`. Detailed reference material is under `guides/`, including `guides/verification-checklists.md`, `guides/troubleshooting.md`, and `guides/common-pitfalls.md`. Swift sample code is split by purpose:

- `guides/samples/step*/` for step-specific migration examples
- `samples/general/` for reusable SwiftUI migration patterns
- `samples/admob/` for AdMob-specific integration samples

Keep new guides close to the workflow step they support, and group new Swift examples by feature or migration stage.

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
This repo relies on documentation accuracy and sample verification rather than an automated test suite. When changing workflow steps or samples, update the related checklist in `guides/verification-checklists.md`. Build any affected sample or target app with `tuist build`, and verify the documented flow still matches the code and screenshots you describe.

## Commit & Pull Request Guidelines
Recent history follows conventional prefixes such as `feat:`, `fix:`, and `update:`. Keep commit subjects short and imperative, for example `fix: correct splash screen path`. PRs should include a brief summary, the docs or samples touched, any related issue, and notes on how you verified the change. Include screenshots only when the change affects UI guidance or visual migration examples.
