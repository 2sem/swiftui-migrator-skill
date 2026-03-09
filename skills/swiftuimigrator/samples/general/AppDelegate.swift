// @UIApplicationMain  // <- DELETE THIS LINE
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, 
                       didFinishLaunchingWithOptions...) -> Bool {
        // ❌ REMOVE - Causes crash with SwiftUI
        // self.window = UIWindow(frame: UIScreen.main.bounds)
        // self.window!.rootViewController = MainViewController()
        // self.window!.makeKeyAndVisible()
        
        // ✅ KEEP - Other initialization is fine
        setupDatabase()
        configureAnalytics()
        
        return true
    }
}