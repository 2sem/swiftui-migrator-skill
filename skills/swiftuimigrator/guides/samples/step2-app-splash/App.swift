import SwiftUI

/// Step 2: Basic App.swift structure
/// File name: App.swift (always)
/// Struct name: Replace "MyApp" with your project name

@main
struct MyAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isSplashDone = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main content will go here in Step 4

                // Splash screen
                if !isSplashDone {
                    SplashScreen(isDone: $isSplashDone)
                        .transition(.opacity)
                }
            }
        }
    }
}
