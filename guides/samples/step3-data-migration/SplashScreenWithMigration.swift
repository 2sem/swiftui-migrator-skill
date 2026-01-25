import SwiftUI
import SwiftData

/// Step 3: SplashScreen with data migration support
/// Uses .task for one-time initialization (better than .onAppear)

struct SplashScreen: View {
    @Binding var isDone: Bool
    @Environment(\.modelContext) private var modelContext

    @State private var loadingMessage = "Loading..."
    @State private var progress: Double = 0.0
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .frame(width: 200)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)

                Text(loadingMessage)
                    .foregroundColor(.white)
                    .font(.headline)

                if progress > 0 && progress < 1 {
                    Text("\(Int(progress * 100))%")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
        .alert("Migration Error", isPresented: $showError) {
            Button("Retry") {
                Task {
                    await performInitialization()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .task {
            // IMPORTANT: Use .task instead of .onAppear
            // - Runs once when view appears
            // - Automatically handles async context
            // - Cancels if view disappears
            await performInitialization()
        }
    }

    private func performInitialization() async {
        do {
            guard let modelContainer = modelContext.container else {
                throw NSError(domain: "Migration", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No model container"])
            }

            // Perform initialization with progress updates
            try await AppInitializer.initialize(
                modelContainer: modelContainer
            ) { message, progressValue in
                Task { @MainActor in
                    loadingMessage = message
                    progress = progressValue
                }
            }

            loadingMessage = "Ready!"
            progress = 1.0
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

            withAnimation {
                isDone = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
