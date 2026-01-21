import SwiftUI

/// Example migrated screen from MainViewController
/// This demonstrates basic SwiftUI patterns for migration
struct MainScreen: View {
    // MARK: - State
    @State private var items: [String] = []
    @State private var isLoading = false
    @State private var showSettings = false
    @State private var showDetail = false

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                if items.isEmpty && !isLoading {
                    emptyStateView
                } else {
                    contentView
                }

                // Loading overlay
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsScreen()
            }
            .task {
                await loadData()
            }
        }
    }

    // MARK: - Subviews
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No items yet")
                .font(.headline)
                .foregroundColor(.gray)

            Button("Refresh") {
                Task {
                    await loadData()
                }
            }
            .buttonStyle(.bordered)
        }
    }

    private var contentView: some View {
        List {
            ForEach(items, id: \.self) { item in
                NavigationLink {
                    DetailScreen(item: item)
                } label: {
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.blue)

                        Text(item)

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    // MARK: - Methods
    private func loadData() async {
        isLoading = true
        defer { isLoading = false }

        // Simulate network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        items = [
            "Item 1",
            "Item 2",
            "Item 3",
            "Item 4",
            "Item 5"
        ]
    }
}

// MARK: - Supporting Screens
struct DetailScreen: View {
    let item: String

    var body: some View {
        VStack {
            Text(item)
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .navigationTitle("Detail")
    }
}

struct SettingsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainScreen()
}
