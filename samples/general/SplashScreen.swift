import SwiftUI

struct SplashScreen: View {
    @Binding var isDone: Bool
    @State private var loadingMessage = "Loading..."
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.blue // Your brand color
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Your logo or loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)

                Text(loadingMessage)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("Retry") {
                Task {
                    await performInitialization()
                }
            }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            Task {
                await performInitialization()
            }
        }
    }

    private func performInitialization() async {
        do {
            loadingMessage = "Initializing..."

            // Add your initialization here
            // Example: try await AppInitializer.initialize()

            // Simulate loading for demo
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

            loadingMessage = "Ready!"
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            withAnimation {
                isDone = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    SplashScreen(isDone: .constant(false))
}
