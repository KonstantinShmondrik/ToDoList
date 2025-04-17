//
//  TestCoreDataService.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 17.04.2025.
//

import Foundation
import CoreData

final class TestCoreDataService: CoreDataService {
    init() {
        guard let modelURL = Bundle(for: TestLocalEntity.self).url(forResource: "TestBase", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load model from bundle")
        }

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "TestBase", managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        super.init(container: container)
    }
}
