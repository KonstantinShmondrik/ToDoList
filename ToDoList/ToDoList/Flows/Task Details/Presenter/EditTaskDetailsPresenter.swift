//
//  EditTaskDetailsPresenterInput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

class EditTaskDetailsPresenter {

    private let task: TaskItem

    weak var view: TaskDetailsViewInput?
    let interactor: TaskDetailsInteractorInput
    let router: TaskDetailsRouterInput

    init(view: TaskDetailsViewInput, interactor: TaskDetailsInteractorInput, router: TaskDetailsRouterInput, task: TaskItem) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.task = task
    }
}

extension EditTaskDetailsPresenter: TaskDetailsPresenterInput {

    var taskId: Int { task.id }

    var taskTitle: String? { task.title }

    var taskDescription: String? { task.description }

    var taskCreatedAt: String? { task.createdAt }

    func didTapSave(item: TaskItem) {
        interactor.updateItem(item) { [weak self] in
            self?.view?.updateTaskList()
        }
    }
}

extension EditTaskDetailsPresenter { }
