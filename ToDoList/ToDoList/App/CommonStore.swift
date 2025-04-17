//
//  CommonStore.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 15.04.2025.
//


final class CommonStore {
    
    static let shared = CommonStore()

    private init() {}

    private lazy var _tasksListCoreDataService: CoreDataService = {
        return CoreDataService(databaseName: .tasksList)
    }()

    var tasksListCoreDataService: CoreDataService {
        return _tasksListCoreDataService
    }
}
