# Suggested Commands

## Important Note
This is a Claude Code skill project (documentation + samples), not a runnable Swift application. Most development commands are not applicable.

## Git Commands
Standard git commands for version control:
```bash
git status
git add .
git commit -m "message"
git push
```

## System Commands (macOS/Darwin)
- `ls` - List directory contents
- `cat` - Display file contents
- `grep` - Search for patterns in files
- `find` - Search for files
- `open` - Open files/directories in default applications

## Commands for Target Projects (Not This Repo)
When users apply this skill to their actual iOS projects, they will use:

### Tuist Commands
```bash
# Regenerate Xcode project after adding new files
mise x -- tuist generate --no-open

# Build the project
tuist build

# Clean build artifacts
tuist clean
```

### Xcode Build Commands
```bash
# Build project
xcodebuild -workspace *.xcworkspace -scheme AppName -configuration Debug build

# Run tests
xcodebuild test -workspace *.xcworkspace -scheme AppName -destination 'platform=iOS Simulator,name=iPhone 15'
```

## No Testing/Linting for This Project
This skill project contains:
- Markdown documentation (SKILL.md, README.md)
- Sample Swift code (non-executable, for reference only)

There are no tests, formatters, or linters configured since the Swift samples are templates, not production code.

## Verification Steps
After modifying the skill:
1. Read through SKILL.md for completeness
2. Verify sample code follows Swift best practices
3. Check that workflow steps are clear and actionable
4. Ensure samples compile syntax-wise (though they reference external dependencies)
