//
//  TaskPreviewRouter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import UIKit

class TaskPreviewRouter {

    let item: TaskItem

    private weak var view: TaskPreviewViewInput?

    init(item: TaskItem) {
        self.item = item
    }

    func compose() -> UIViewController {
        let viewController = TaskPreviewViewController(task: item)
        self.view = viewController

        let interactor = TaskPreviewInteractor()
        let presenter = TaskPreviewPresenter(view: viewController, interactor: interactor, router: self)

        interactor.output = presenter
        viewController.presenter = presenter

        return viewController
    }

}

extension TaskPreviewRouter: TaskPreviewRouterInput {

}
