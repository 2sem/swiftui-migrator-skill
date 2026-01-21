# Code Style and Conventions

## Swift Code Style
Based on samples provided, following Paul Hudson and Antoine van der Lee's approaches:

### Naming Conventions
- **Classes**: PascalCase (e.g., `SwiftUIAdManager`)
- **Properties**: camelCase (e.g., `isSetupDone`, `canShowFirstTime`)
- **Methods**: camelCase with descriptive names (e.g., `requestAppTrackingIfNeed()`)
- **Enums**: PascalCase with lowercase cases (e.g., `GADUnitName.full`, `.launch`)

### Code Organization
- **MARK comments**: Use to separate logical sections (e.g., `// MARK: - Testing Flags`)
- **Extensions**: Separate protocol conformances into extensions
- **Access control**: Use `private` for internal implementation details

### SwiftUI Patterns
- **State management**: 
  - `@StateObject` for owned observable objects
  - `@EnvironmentObject` for dependency injection
  - `@AppStorage` for user defaults
  - `@State` for local view state
- **Lifecycle**: Use `.onAppear` and `.onChange(of:)` for side effects
- **Async/await**: Prefer modern concurrency over completion handlers

### Comments
- Korean comments are acceptable and used in samples (e.g., "싱글톤 패턴으로 전역 접근 지원")
- English doc comments for public APIs using `///` syntax
- Inline comments explain non-obvious business logic

### Error Handling
- Guard statements for early returns
- Optional chaining for safe unwrapping
- `defer` for cleanup logic

### Async Patterns
- Use `@MainActor` for UI-related async functions
- `withCheckedContinuation` for bridging callback-based APIs
- `Task {}` blocks for fire-and-forget async operations

### Type Safety
- Prefer type-safe enums over string literals (e.g., `GADUnitName` enum)
- Use generics where appropriate (e.g., `GADManager<GADUnitName>`)
