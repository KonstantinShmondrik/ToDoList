//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import CoreData

class CoreDataService {

    enum DatabaseName: String {
        case tasksList = "TaskListDataBase"
    }

    private let databaseName: DatabaseName

    init(databaseName: DatabaseName) {
        self.databaseName = databaseName
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: databaseName.rawValue)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                Logger.log("Unresolved error \(error), \(error.userInfo)", level: .error)
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    // MARK: - Save
    func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            Logger.log("Core Data Save Error: \(error)", level: .error)
        }
    }

    // MARK: - Async Save
    func saveAsync(_ context: NSManagedObjectContext) async throws {
        if context.hasChanges {
            try context.save()
        }
    }

    // MARK: - Create
    func create<T: NSManagedObject>(
        inBackground: Bool = false,
        isSaveRequired: Bool = true,
        completion: @escaping (T) -> Void
    ) {
        let block: (NSManagedObjectContext) -> Void = { context in
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }
            let object = T(context: context)
            completion(object)
            if isSaveRequired {
                self.save(context)
            }
        }

        if inBackground {
            persistentContainer.performBackgroundTask(block)
        } else {
            block(viewContext)
        }
    }

    func createAsync<T: NSManagedObject>(
        inBackground: Bool = false,
        isSaveRequired: Bool = true,
        configure: @escaping (T) -> Void
    ) async throws {
        let context = inBackground ? backgroundContext : viewContext
        await context.perform {
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }
            let object = T(context: context)
            configure(object)
            if isSaveRequired {
                self.save(context)
            }
        }
    }

    // MARK: - Fetch One
    func fetchOneAsync<T: NSManagedObject>(
        with predicate: NSPredicate,
        inBackground: Bool = false,
        prefetchingRelationships: [String]? = nil
    ) async throws -> T? {
        let context = inBackground ? backgroundContext : viewContext
        return try await context.perform {
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            if let prefetch = prefetchingRelationships {
                request.relationshipKeyPathsForPrefetching = prefetch
            }
            return try context.fetch(request).first
        }
    }

    // MARK: - Fetch All
    func fetchAllAsync<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        inBackground: Bool = false
    ) async throws -> [T] {
        let context = inBackground ? backgroundContext : viewContext
        return try await context.perform {
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.returnsObjectsAsFaults = false
            return try context.fetch(request)
        }
    }

    // MARK: - Update
    func updateAsync<T: NSManagedObject>(
        predicate: NSPredicate,
        inBackground: Bool = false,
        updateBlock: @escaping (T) -> Void
    ) async throws {
        let context = inBackground ? backgroundContext : viewContext
        try await context.perform {
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            if let object = try context.fetch(request).first {
                updateBlock(object)
                self.save(context)
            }
        }
    }

    // MARK: - Delete One by Predicate
    func deleteOneAsync<T: NSManagedObject>(
        type: T.Type,
        with predicate: NSPredicate,
        inBackground: Bool = false
    ) async throws {
        let context = inBackground ? backgroundContext : viewContext
        try await context.perform {
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }
            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            if let object = try context.fetch(request).first {
                context.delete(object)
                self.save(context)
            }
        }
    }

    // MARK: - Delete All
    func deleteAllAsync<T: NSManagedObject>(
        type: T.Type,
        inBackground: Bool = false
    ) async throws {
        let context = inBackground ? backgroundContext : viewContext
        try await context.perform {
            if Thread.isMainThread {
                Logger.log("main thread.", level: .warning)
            } else {
                Logger.log("background thread.", level: .info)
            }

            let request = NSFetchRequest<T>(entityName: String(describing: T.self))
            let objects = try context.fetch(request)
            objects.forEach { context.delete($0) }
            self.save(context)
        }
    }

    // MARK: - Recreate Database
    func recreateDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }

        do {
            let coordinator = persistentContainer.persistentStoreCoordinator
            viewContext.reset()
            try coordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            viewContext.reset()
        } catch {
            Logger.log("\(error)", level: .error)
        }
    }
}
