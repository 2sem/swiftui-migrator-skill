import SwiftUI

// MARK: - UserDefaults → @AppStorage

// UIKit
func saveAndLoadUserDefaults() {
    UserDefaults.standard.set(true, forKey: "isDarkMode")
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    print("UIKit UserDefaults isDarkMode: \(isDarkMode)")
}

// SwiftUI
struct AppStorageView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        Toggle("Dark Mode", isOn: $isDarkMode)
    }
}
