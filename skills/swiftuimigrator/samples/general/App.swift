import SwiftUI
import SwiftData // Swift Data Migration Step

/// IMPORTANT: This file should ALWAYS be named `App.swift`
/// - File name: App.swift (always the same, never changes)
/// - Struct name: MyAppApp (replace "MyApp" with your actual project name)
/// - Example: If your project is "TodoList", struct would be `TodoListApp`

@main
struct ProjectNameApp: App {  // Replace "ProjectName" with your project name
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isSplashDone = false
    // // For App Life Cycle Migration Step
    @State private var isLaunched = false
    @State private var isFromBackground = false

    // For Swift Data Migration Step
    var modelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            // Add all your @Model classes here
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // For Main Screen Insert Step
                if isSplashDone {
                    MainScreen()
                        .transition(.opacity)
                }

                // For Splash Screen Insert Step
                if !isSplashDone {
                    SplashScreen(isDone: $isSplashDone)
                        .transition(.opacity)
                }
            }
            // For App Life Cycle Migration Step
            .onChange(of: scenePhase) { oldPhase, newPhase in
                handleScenePhaseChange(from: oldPhase, to: newPhase)
            }
        }
        // For Swift Data Migration Step
        .modelContainer(modelContainer)
    }

    // For App Life Cycle Migration Step
    private func handleScenePhaseChange(from oldPhase: ScenePhase, to newPhase: ScenePhase) {
        print("scene changed old[\(oldPhase)] new[\(newPhase)]")
        
        switch newPhase {
        case .active:
            handleAppDidBecomeActive()
        case .inactive:
            // from applicationWillResignActive
            break
        case .background:
            // from applicationDidEnterBackground
            isFromBackground = true
            break
        @unknown default:
            break
        }
    }
    
    // For App Life Cycle Migration Step from applicationWillEnterForeground
    private func handleAppDidBecomeActive() {
        print("scene become active")

        if !isLaunched { // First launch
            isLaunched = true
            LSDefaults.increaseLaunchCount()
        } else if isFromBackground { // Returning from background
            Task {
                await adManager.requestAppTrackingIfNeed()
                await adManager.show(unit: .launch)
            }
        }
        // If it's just returning from inactive (system alert), do nothing.

        isFromBackground = false // Reset the flag here.
    }
}
