//
//  TaskDetailsBuilder.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 26.08.2025.
//

import UIKit

enum TaskDetailsBuilder {

    static func build(task: TaskItem?) -> UIViewController {
        let viewController = TaskDetailsViewController()
        let interactor = TaskDetailsInteractor()
        let router = TaskDetailsRouter()

        let presenter: TaskDetailsPresenterInput

        if let task {
            presenter = EditTaskDetailsPresenter(view: viewController, interactor: interactor, router: router, task: task)
        } else {
            presenter = NewTaskDetailsPresenter(view: viewController, interactor: interactor, router: router)
        }

        interactor.output = presenter
        viewController.presenter = presenter
        router.view = viewController

        return viewController
    }
}
