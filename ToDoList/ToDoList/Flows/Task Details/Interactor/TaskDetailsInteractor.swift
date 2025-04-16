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
