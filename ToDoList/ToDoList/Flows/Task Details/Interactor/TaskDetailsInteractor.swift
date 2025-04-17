//
//  TaskDetailsInteractor.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import Foundation

class TaskDetailsInteractor {

    weak var output: TaskDetailsInteractorOutput?

    private lazy var coreDataService = CommonStore.shared.tasksListCoreDataService

}

extension TaskDetailsInteractor: TaskDetailsInteractorInput {

    func updateItem(_ item: TaskItem, completion: (() -> Void)? = nil) {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: Int32(item.id)))
        do {
            try coreDataService.update(with: predicate) { (object: TaskListLocal) in
                object.title = item.title
                object.todo = item.description

                completion?()
            }
        } catch {
            Logger.log("Failed to update task: \(error)", level: .error)
        }
    }
    
    func createItem(_ item: TaskItem, completion: (() -> Void)? = nil) {
        coreDataService.create(isSaveRequired: true) { (object: TaskListLocal) in
            object.id = Int32(item.id)
            object.title = item.title
            object.todo = item.description
            object.isCompleted = item.isCompleted
            object.userID = Int32(item.userID)
            object.createdAt = Date.now
            completion?()
        }
    }

    func generateNewTaskID() -> Int {
        do {
            let allTasks: [TaskListLocal] = try coreDataService.all()
            let maxID = allTasks.map { $0.id }.max() ?? 0
            return Int(maxID + 1)
        } catch {
            Logger.log("Failed to fetch tasks: \(error)", level: .error)
            return 1
        }
    }
}
