//
//  TaskPreviewBuilder.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 26.08.2025.
//

import UIKit

enum TaskPreviewBuilder {

    static func build(item: TaskItem) -> UIViewController {
        let viewController = TaskPreviewViewController(task: item)
        let interactor = TaskPreviewInteractor()
        let router = TaskPreviewRouter()
        let presenter = TaskPreviewPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )

        interactor.output = presenter
        viewController.presenter = presenter
        router.view = viewController

        return viewController
    }
}
