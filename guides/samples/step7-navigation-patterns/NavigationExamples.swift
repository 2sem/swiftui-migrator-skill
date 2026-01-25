import SwiftUI
import UIKit

// MARK: - Navigation Patterns

// --- Screens used in the examples ---
struct DetailScreen: View { var body: some View { Text("Detail Screen") } }
struct SettingsScreen: View { var body: some View { Text("Settings Screen") } }
struct OnboardingScreen: View { var body: some View { Text("Onboarding Screen") } }
struct HomeScreen: View { var body: some View { Text("Home Screen") } }
struct SearchScreen: View { var body: some View { Text("Search Screen") } }

class DetailVC: UIViewController {}
class SettingsVC: UIViewController {}


// MARK: - A. Push Navigation
// UIKit
// navigationController?.pushViewController(DetailVC(), animated: true)

// SwiftUI
struct PushNavigationView: View {
    var body: some View {
        NavigationView {
            NavigationLink("Go to Detail") {
                DetailScreen()
            }
        }
    }
}


// MARK: - B. Modal Presentation (.sheet)
// UIKit
// present(SettingsVC(), animated: true)

// SwiftUI
struct ModalSheetView: View {
    @State private var showSettings = false

    var body: some View {
        Button("Settings") {
            showSettings = true
        }
        .sheet(isPresented: $showSettings) {
            SettingsScreen()
        }
    }
}


// MARK: - C. Full Screen Cover (.fullScreenCover)
struct FullScreenCoverView: View {
    @State private var showOnboarding = false

    var body: some View {
        Button("Show Onboarding") {
            showOnboarding = true
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingScreen()
        }
    }
}


// MARK: - 4. TabBar Screens (TabView)
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchScreen()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
