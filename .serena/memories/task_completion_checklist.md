# Task Completion Checklist

## When Editing This Skill Project

### After Modifying SKILL.md (Main Workflow)
- [ ] Verify all 9 steps are present and clearly numbered
- [ ] Check that verification sections are present after each step
- [ ] Ensure common migration patterns are accurate (UIKit → SwiftUI)
- [ ] Validate that sample references point to correct files (samples/general/)
- [ ] Confirm sub-guide references are correct (guides/admob-migration.md)
- [ ] Check troubleshooting section is comprehensive
- [ ] **Critical guideline present**: "When SwiftUI has issues → re-read UIKit implementation"

### After Modifying Sub-Guides (guides/*.md)
- [ ] Ensure sub-guide clearly states when to use it (e.g., Step 8)
- [ ] Check that sample paths reference correct location (samples/admob/)
- [ ] Verify workflow steps are numbered correctly
- [ ] Ensure verification sections are present
- [ ] Validate that it references back to main SKILL.md when appropriate

### After Modifying General Sample Code (samples/general/)
- [ ] Ensure code follows Swift conventions (see code_style_conventions.md)
- [ ] Check that imports are minimal and correct
- [ ] Verify async/await patterns are used correctly
- [ ] Confirm @MainActor annotations where needed
- [ ] Check property wrappers (@State, @StateObject, @Binding, @AppStorage)
- [ ] Ensure code compiles syntax-wise
- [ ] Verify code demonstrates best practices
- [ ] Check that comments explain non-obvious logic
- [ ] **File naming**: App.swift (NOT MyAppApp.swift or {ProjectName}App.swift)
- [ ] **Struct naming**: Use generic placeholder `MyAppApp` (not specific project names)
- [ ] **Screen naming**: Use meaningful names like `MainScreen.swift`, NOT `ContentView.swift`

### After Modifying Step-Specific Samples (guides/samples/step*/)\n- [ ] All checks from general samples above
- [ ] Ensure sample demonstrates the specific step it's in
- [ ] Check that SKILL.md references the correct sample path
- [ ] Verify sample shows progressive complexity (Step 2 simpler than Step 4)
- [ ] Confirm sample includes comments explaining the pattern
- [ ] Check that sample aligns with the step's verification checklist

### After Modifying AdMob Sample Code (samples/admob/)
- [ ] All checks from general samples above
- [ ] Check GoogleMobileAds and GADManager imports
- [ ] Verify UserDefaults references (LSDefaults is example name)
- [ ] Confirm GADManagerDelegate implementation is complete
- [ ] Check ad timing and launch count logic
- [ ] Ensure test unit configuration is present

### After Modifying README.md
- [ ] Update 9-step workflow summary if steps changed
- [ ] Check that project structure diagram matches actual structure
- [ ] Verify all sub-guides are listed
- [ ] Ensure quick start guide is accurate
- [ ] Check that examples match sample code
- [ ] Verify links are functional (relative paths)

### Git Workflow
Since this is a git repository:
1. **Check status**: `git status` to see what changed
2. **Review changes**: Examine diffs before committing
3. **Stage changes**: `git add .` or stage specific files
4. **Commit changes**: Use descriptive commit messages referencing the workflow step or feature
5. **Push if needed**: `git push` to sync with remote

### No Build/Test Steps
This project does not require:
- Running builds (samples are not compiled as a project)
- Running tests (no test suite)
- Running linters (documentation project)
- Formatting code (samples are already formatted)

**However**, sample code should be syntactically correct and demonstrate working patterns.

### Common Pitfalls to Avoid
Based on SKILL.md "Common Pitfalls" section:
- Don't reference non-existent files in workflow steps
- Keep Tuist project structure assumptions explicit
- Maintain consistency between SKILL.md, guides/, and samples/
- Remember that users will adapt samples to their project structure
- Ensure sub-guides clearly state when to use them (e.g., Step 8 for AdMob)
- Don't mix paths between samples/general/ and samples/admob/

### After Adding New Sub-Guide
- [ ] Create guide in guides/ directory
- [ ] Reference it from SKILL.md at appropriate step
- [ ] Add it to README.md sub-guides section
- [ ] Create corresponding samples in samples/{feature}/ if needed
- [ ] Update project_structure.md memory

### After Adding New Sample Category
- [ ] Create subdirectory in samples/ (e.g., samples/coredata/)
- [ ] Add corresponding sub-guide in guides/
- [ ] Update README.md project structure
- [ ] Update project_structure.md memory
- [ ] Ensure SKILL.md references it appropriately

## Agent Debugging Guidelines

### When Agent Encounters SwiftUI Implementation Issues

**CRITICAL WORKFLOW**: If the SwiftUI version has problems:

1. **Stop and re-read the UIKit implementation**
   - Open the original ViewController file
   - Look for what was missed in the SwiftUI migration
   
2. **Common things agents miss**:
   - Initial state values (selectedIndex, default values)
   - `viewDidLoad` initialization → Should be `.task` or `.onAppear`
   - `viewWillAppear` logic → Should be `.onAppear` or `.task`
   - Delegate methods → Need callbacks or `@Binding`
   - Property observers (`didSet`, `willSet`) → Need `@Published` or manual tracking
   - UIKit-specific configuration (navigationItem, tabBarItem)
   
3. **Example patterns to look for**:
   - `tabBarController.selectedIndex = 1` → Need `@State var selectedTab = 1` and `TabView(selection: $selectedTab)`
   - `navigationItem.title = "Foo"` → Need `.navigationTitle("Foo")`
   - `tableView.delegate = self` → Need NavigationLink or .onTapGesture
   - Timer setup in viewDidLoad → Need .onAppear or .task with Timer.publish
   
4. **Remember**: UIKit ViewControllers are kept during migration specifically for reference when debugging

## Verification After Major Changes

After significant restructuring or content updates:
1. Read through SKILL.md from start to finish
2. Verify all sample paths are correct
3. Check that sub-guide references work
4. Ensure README.md reflects current structure
5. Verify memory files are up to date
6. Test that a new user could follow the workflow
