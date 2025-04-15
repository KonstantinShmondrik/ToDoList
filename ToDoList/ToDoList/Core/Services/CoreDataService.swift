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
        return container
    }()

    private var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        let context = self.context
        let queue = DispatchQueue(label: "com.coredata.queue", attributes: .concurrent)

        let group = DispatchGroup()
        group.enter()

        queue.async {
            if context.hasChanges {
                do {
                    try context.save()
                    if Thread.isMainThread {
                        Logger.log("Context successfully saved on the main thread.", level: .warning)
                    } else {
                        Logger.log("Context successfully saved on background thread", level: .info)
                    }
                } catch {
                    let nserror = error as NSError
                    Logger.log("Unresolved error \(nserror), \(nserror.userInfo)", level: .error)
                }
            } else {
                Logger.log("No changes in context to save.", level: .info)
            }

            group.leave()
        }

        group.wait()
    }

    func create<T: NSManagedObject>(isSaveRequired: Bool, completion: (T) -> Void) {
        let object = T(context: context)
        completion(object)

        if isSaveRequired {
            saveContext()
        }
    }

    func object<T: NSManagedObject>(
        with predicate: NSPredicate,
        prefetchingRelationships: [String]? = nil
    ) throws -> T? {
        var result: T?

        let context = self.context
        let queue = DispatchQueue(label: "com.coredata.queue", attributes: .concurrent)
        let group = DispatchGroup()
        var fetchError: Error?

        group.enter()

        queue.async {
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            request.returnsObjectsAsFaults = false

            if let prefetchingRelationships = prefetchingRelationships {
                request.relationshipKeyPathsForPrefetching = prefetchingRelationships
            }

            if Thread.isMainThread {
                Logger.log("CoreData fetch (object<T>) is being made on the main thread.", level: .warning)
            } else {
                Logger.log("CoreData fetch (object<T>) is being made on a background thread.", level: .info)
            }

            do {
                result = try context.fetch(request).first
            } catch {
                fetchError = error
                Logger.log("Failed fetching object: \(error)", level: .error)
            }

            group.leave()
        }

        group.wait()

        if let error = fetchError {
            throw error
        }

        return result
    }


    func update<T: NSManagedObject>(with predicate: NSPredicate, completion: (T) -> Void) throws {
        guard let object: T = try object(with: predicate) else { return }
        completion(object)
        saveContext()
    }

    func all<T: NSManagedObject>(
        with predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        var result: [T] = []

        let context = self.context
        let queue = DispatchQueue(label: "com.coredata.queue", attributes: .concurrent)

        let group = DispatchGroup()
        group.enter()

        queue.async {
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.returnsObjectsAsFaults = false

            if Thread.isMainThread {
                Logger.log("CoreData fetch request is being made on the main thread.", level: .warning)
            } else {
                Logger.log("CoreData fetch request is being made on a background thread.", level: .info)
            }

            do {
                result = try context.fetch(request)
            } catch {
                Logger.log("Failed fetching data: \(error)", level: .error)
            }

            group.leave()
        }

        group.wait()
        return result
    }

    func delete<T: NSManagedObject>(object: T, isSaveNeeded: Bool = true) {
        let context = self.context
        let queue = DispatchQueue(label: "com.coredata.queue", attributes: .concurrent)

        queue.async(flags: .barrier) {
            if Thread.isMainThread {
                Logger.log("CoreData delete request is being made on the main thread.", level: .warning)
            } else {
                Logger.log("CoreData delete request is being made on a background thread.", level: .info)
            }

            context.delete(object)
            Logger.log("Deleted object of type \(T.self)", level: .info)

            if isSaveNeeded && context.hasChanges {
                do {
                    try context.save()
                    Logger.log("Context saved after deletion.", level: .info)
                } catch {
                    let nserror = error as NSError
                    Logger.log("Failed to save context after deletion: \(nserror), \(nserror.userInfo)", level: .error)
                }
            }
        }
    }

    func deleteAll<T: NSManagedObject>(type: T.Type) throws {
        let objects: [T] = try all()
        objects.forEach { delete(object: $0) }
    }

    func recreateDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }

        do {
            let coordinator = persistentContainer.persistentStoreCoordinator
            context.reset()

            try coordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            context.reset()
        } catch {
            Logger.log("\(error)", level: .error)
        }
    }
}
