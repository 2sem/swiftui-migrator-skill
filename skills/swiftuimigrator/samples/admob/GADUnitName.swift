extension SwiftUIAdManager {
    enum GADUnitName: String {
        // Example: Copy these from GADUnitIdentifiers in Projects/App/Project.swift
        case full = "FullAd"
        case launch = "Launch"
        case native = "Native"
        case homeBanner = "HomeBanner"
        case settingsBanner = "SettingsBanner"
        // Add more cases as needed from your GADUnitIdentifiers
    }

#if DEBUG
    var testUnits: [GADUnitName] {
        // List all cases here for testing mode
        [.full, .launch, .native, .homeBanner, .settingsBanner]
    }
#else
    var testUnits: [GADUnitName] { [] }
#endif

}
