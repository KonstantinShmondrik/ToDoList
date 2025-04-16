//
//  TaskDetailsRouter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import UIKit

class TaskDetailsRouter {

    private weak var view: TaskDetailsViewInput?

    func compose(for task: TaskItem?) -> UIViewController {
        let viewController = TaskDetailsViewController()
        self.view = viewController

        let interactor = TaskDetailsInteractor()
        let presenter: TaskDetailsPresenterInput

        if let task {
            presenter = EditTaskDetailsPresenter(view: viewController, interactor: interactor, router: self, task: task)
        } else {
            presenter = NewTaskDetailsPresenter(view: viewController, interactor: interactor, router: self)
        }

        interactor.output = presenter
        viewController.presenter = presenter

        return viewController
    }

}

extension TaskDetailsRouter: TaskDetailsRouterInput {

}
