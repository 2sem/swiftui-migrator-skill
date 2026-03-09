extension SwiftUIAdManager {
    enum GADUnitName: String {
        // Example: Copy these from GADUnitIdentifiers in Projects/App/Project.swift
        case full = "ca-app-pub-xxx/FullAd"
        case launch = "ca-app-pub-xxx/AppLaunch"
        case donate = "ca-app-pub-xxx/Donate"
        // Add more cases as needed from your GADUnitIdentifiers
    }
    
#if DEBUG
    var testUnits: [GADUnitName] {
        // List all cases here for testing mode
        [.full, .launch, .donate]
    }
#else
    var testUnits: [GADUnitName] { [] }
#endif
    
}