import SwiftUI

/// Step 2: Basic SplashScreen (no initialization yet)
/// Will add initialization logic in Step 3

struct SplashScreen: View {
    @Binding var isDone: Bool

    var body: some View {
        ZStack {
            Color.blue // Your brand color
                .ignoresSafeArea()

            VStack {
                // Your logo or loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
        .task {
            // IMPORTANT: Use .task instead of .onAppear for one-time async initialization
            // .task runs once when view appears and auto-handles cancellation
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

            withAnimation {
                isDone = true
            }
        }
    }
}
