import Foundation
import CoreData
import SwiftData

/// Handles migration from Core Data to Swift Data
/// Observable object for real-time progress updates in SplashScreen
@MainActor
class DataMigrationManager: ObservableObject {
    @Published var migrationProgress: Double = 0.0
    @Published var migrationStatus: MigrationStatus = .idle
    @Published var currentStep: String = ""

    enum MigrationStatus {
        case idle
        case checking
        case migrating
        case completed
        case failed(Error)
    }

    // Your Core Data controller (replace with your actual implementation)
    private let coreDataController = CoreDataController.shared

    var isMigrationCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: "dataMigrationCompleted") }
        set { UserDefaults.standard.set(newValue, forKey: "dataMigrationCompleted") }
    }

    /// Main entry point - checks if migration is needed and performs it
    /// - Returns: true if migration was performed, false if skipped
    func checkAndMigrateIfNeeded(modelContext: ModelContext) async -> Bool {
        print("[DataMigration] checkAndMigrateIfNeeded started")

        if isMigrationCompleted {
            print("[DataMigration] Migration already completed")
            migrationStatus = .completed
            currentStep = "Migration already completed"
            return false
        }

        migrationStatus = .checking
        currentStep = "Checking for Core Data..."
        print("[DataMigration] Checking for Core Data")

        guard await hasCoreData() else {
            print("[DataMigration] No Core Data found, migration not needed")
            migrationStatus = .completed
            currentStep = "No migration needed"
            isMigrationCompleted = true
            return false
        }

        migrationStatus = .migrating
        currentStep = "Starting migration..."
        print("[DataMigration] Core Data found, starting migration")

        do {
            try await performMigration(modelContext: modelContext)
            print("[DataMigration] Migration completed successfully")
            migrationStatus = .completed
            currentStep = "Migration completed"
            isMigrationCompleted = true
            return true
        } catch {
            print("[DataMigration] Migration failed: \(error.localizedDescription)")
            migrationStatus = .failed(error)
            currentStep = "Migration failed: \(error.localizedDescription)"
            return false
        }
    }

    /// Check if Core Data has any data to migrate
    private func hasCoreData() async -> Bool {
        print("[DataMigration] Checking Core Data entities")
        let context = coreDataController.context

        return await withCheckedContinuation { continuation in
            context.perform {
                // Replace with your actual entity names
                let favoriteRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Favorite")
                favoriteRequest.fetchLimit = 1

                let itemRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Item")
                itemRequest.fetchLimit = 1

                do {
                    let favoriteCount = try context.count(for: favoriteRequest)
                    let itemCount = try context.count(for: itemRequest)
                    let hasData = favoriteCount > 0 || itemCount > 0

                    print("[DataMigration] Core Data check - favorites: \(favoriteCount), items: \(itemCount), hasData: \(hasData)")
                    continuation.resume(returning: hasData)
                } catch {
                    print("[DataMigration] Error checking Core Data: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }

    /// Perform the actual migration
    private func performMigration(modelContext: ModelContext) async throws {
        print("[DataMigration] performMigration started")

        // Step 1: Migrate favorites (example entity)
        currentStep = "Migrating favorites..."
        migrationProgress = 0.1
        print("[DataMigration] Starting favorites migration")

        try await migrateFavorites(with: modelContext)
        print("[DataMigration] Favorites migration completed")

        // Step 2: Migrate items (example entity)
        currentStep = "Migrating items..."
        migrationProgress = 0.5
        print("[DataMigration] Starting items migration")

        try await migrateItems(with: modelContext)
        print("[DataMigration] Items migration completed")

        // Step 3: Cleanup old Core Data files
        currentStep = "Cleaning up..."
        migrationProgress = 0.9
        print("[DataMigration] Starting cleanup")

        await cleanupCoreDataFiles()
        print("[DataMigration] Cleanup completed")

        migrationProgress = 1.0
    }

    /// Migrate Favorites from Core Data to Swift Data
    private func migrateFavorites(with modelContext: ModelContext) async throws {
        print("[DataMigration] Fetching Core Data favorites")
        let context = coreDataController.context

        let coreDataFavorites = try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Favorite")

                do {
                    let favorites = try context.fetch(fetchRequest)
                    print("[DataMigration] Fetched \(favorites.count) favorites from Core Data")
                    continuation.resume(returning: favorites)
                } catch {
                    print("[DataMigration] Error fetching favorites: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }

        let totalItems = coreDataFavorites.count
        print("[DataMigration] Starting migration of \(totalItems) favorites")

        for (i, favorite) in coreDataFavorites.enumerated() {
            // Extract data from Core Data object
            guard let id = favorite.value(forKey: "id") as? Int64,
                  let name = favorite.value(forKey: "name") as? String,
                  let createdAt = favorite.value(forKey: "createdAt") as? Date else {
                print("[DataMigration] Warning: Invalid favorite data at index \(i)")
                continue
            }

            // Create Swift Data model
            let swiftDataFavorite = Favorite(
                id: Int(id),
                name: name,
                createdAt: createdAt
            )
            modelContext.insert(swiftDataFavorite)

            // Batch save every 100 items for performance
            if (i + 1) % 100 == 0 {
                try modelContext.save()
                print("[DataMigration] Saved batch at \(i + 1) items")
            }

            // Update progress every 10 items or at the end
            if (i + 1) % 10 == 0 || i == totalItems - 1 {
                let progress = 0.1 + (Double(i + 1) / Double(totalItems)) * 0.4
                await MainActor.run {
                    self.migrationProgress = min(progress, 0.5)
                }
            }
        }

        // Final save
        try modelContext.save()
        print("[DataMigration] Saved \(totalItems) favorites to SwiftData")
    }

    /// Migrate Items from Core Data to Swift Data
    private func migrateItems(with modelContext: ModelContext) async throws {
        print("[DataMigration] Fetching Core Data items")
        let context = coreDataController.context

        let coreDataItems = try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Item")

                do {
                    let items = try context.fetch(fetchRequest)
                    print("[DataMigration] Fetched \(items.count) items from Core Data")
                    continuation.resume(returning: items)
                } catch {
                    print("[DataMigration] Error fetching items: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }

        let totalItems = coreDataItems.count
        print("[DataMigration] Starting migration of \(totalItems) items")

        for (i, item) in coreDataItems.enumerated() {
            // Extract data from Core Data object
            guard let id = item.value(forKey: "id") as? Int64,
                  let title = item.value(forKey: "title") as? String else {
                print("[DataMigration] Warning: Invalid item data at index \(i)")
                continue
            }

            // Handle optional fields
            let notes = item.value(forKey: "notes") as? String
            let isCompleted = item.value(forKey: "isCompleted") as? Bool ?? false

            // Create Swift Data model
            let swiftDataItem = Item(
                id: Int(id),
                title: title,
                notes: notes,
                isCompleted: isCompleted
            )
            modelContext.insert(swiftDataItem)

            // Batch save every 100 items
            if (i + 1) % 100 == 0 {
                try modelContext.save()
                print("[DataMigration] Saved batch at \(i + 1) items")
            }

            // Update progress
            if (i + 1) % 10 == 0 || i == totalItems - 1 {
                let progress = 0.5 + (Double(i + 1) / Double(totalItems)) * 0.4
                await MainActor.run {
                    self.migrationProgress = min(progress, 0.9)
                }
            }
        }

        // Final save
        try modelContext.save()
        print("[DataMigration] Saved \(totalItems) items to SwiftData")
    }

    /// Clean up old Core Data files after successful migration
    private func cleanupCoreDataFiles() async {
        print("[DataMigration] Starting Core Data files cleanup")

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let docUrl = urls.last else {
            print("[DataMigration] Warning: Could not get document directory for cleanup")
            return
        }

        // Replace "YourDataModelName" with your actual .xcdatamodeld file name
        let modelName = "YourDataModelName"
        let sqliteURL = docUrl.appendingPathComponent(modelName).appendingPathExtension("sqlite")
        let sqliteShmURL = docUrl.appendingPathComponent(modelName).appendingPathExtension("sqlite-shm")
        let sqliteWalURL = docUrl.appendingPathComponent(modelName).appendingPathExtension("sqlite-wal")

        do {
            try FileManager.default.removeItem(at: sqliteURL)
            print("[DataMigration] Removed \(sqliteURL.lastPathComponent)")
        } catch {
            print("[DataMigration] Could not remove sqlite file: \(error)")
        }

        do {
            try FileManager.default.removeItem(at: sqliteShmURL)
            print("[DataMigration] Removed \(sqliteShmURL.lastPathComponent)")
        } catch {
            print("[DataMigration] Could not remove sqlite-shm file: \(error)")
        }

        do {
            try FileManager.default.removeItem(at: sqliteWalURL)
            print("[DataMigration] Removed \(sqliteWalURL.lastPathComponent)")
        } catch {
            print("[DataMigration] Could not remove sqlite-wal file: \(error)")
        }

        print("[DataMigration] Core Data files cleanup completed")
    }
}

// MARK: - Core Data Controller (Replace with your actual implementation)

class CoreDataController {
    static let shared = CoreDataController()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourDataModelName")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}

// MARK: - Swift Data Models (Examples)

@Model
final class Favorite {
    var id: Int
    var name: String
    var createdAt: Date

    init(id: Int, name: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}

@Model
final class Item {
    var id: Int
    var title: String
    var notes: String?
    var isCompleted: Bool

    init(id: Int, title: String, notes: String? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
    }
}
