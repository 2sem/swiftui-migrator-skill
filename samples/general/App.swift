import SwiftUI

/// IMPORTANT: This file should ALWAYS be named `App.swift`
/// - File name: App.swift (always the same, never changes)
/// - Struct name: MyAppApp (replace "MyApp" with your actual project name)
/// - Example: If your project is "TodoList", struct would be `TodoListApp`

@main
struct MyAppApp: App {  // Replace "MyApp" with your project name
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isSplashDone = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main content
                if isSplashDone {
                    MainScreen()
                        .transition(.opacity)
                }

                // Splash overlay
                if !isSplashDone {
                    SplashScreen(isDone: $isSplashDone)
                        .transition(.opacity)
                }
            }
        }
    }
}
