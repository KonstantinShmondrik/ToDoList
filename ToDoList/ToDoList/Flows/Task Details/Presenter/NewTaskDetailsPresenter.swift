//
//  NewTaskDetailsPresenter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import Foundation

class NewTaskDetailsPresenter {

    weak var view: TaskDetailsViewInput?
    let interactor: TaskDetailsInteractorInput
    let router: TaskDetailsRouterInput

    init(view: TaskDetailsViewInput, interactor: TaskDetailsInteractorInput, router: TaskDetailsRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension NewTaskDetailsPresenter: TaskDetailsPresenterInput {

    var taskId: Int { interactor.generateNewTaskID() }

    var taskTitle: String? { "\(taskId) Задача" }

    var taskDescription: String? { nil }

    var taskCreatedAt: String? { Date.now.formattedAsDayMonthYear }

    func viewDidLoad() {

    }
    
    func didTapSave(title: String, description: String) {
        
    }
}

extension NewTaskDetailsPresenter {


}
