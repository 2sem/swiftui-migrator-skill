import SwiftUI
import Combine

// Dummy Item struct
struct Item: Identifiable, Decodable {
    let id = UUID()
    let name: String
}

// Dummy NetworkService
struct NetworkService {
    static func fetchItems(completion: @escaping ([Item]) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([Item(name: "Item from closure")])
        }
    }
    
    static func fetchItems() async throws -> [Item] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return [Item(name: "Item from async/await")]
    }
}

// MARK: - Data Loading with @StateObject

// UIKit
class DataLoadingViewController: UIViewController {
    var data: [Item] = []
    var tableView = UITableView() // Assuming a tableview exists

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        NetworkService.fetchItems { [weak self] items in
            self?.data = items
            self?.tableView.reloadData()
        }
    }
}

// SwiftUI
@MainActor
class MainViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false

    func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            items = try await NetworkService.fetchItems()
        } catch {
            print("Error: \(error)")
        }
    }
}

struct DataLoadingView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        List(viewModel.items) { item in
            Text(item.name)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
