//
//  TaskDetailsPresenterInput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

protocol TaskDetailsPresenterInput: TaskDetailsInteractorOutput {

    var taskId: Int { get }
    var taskTitle: String? { get }
    var taskDescription: String? { get }
    var taskCreatedAt: String? { get }

    func didTapSave(item: TaskItem)
}
