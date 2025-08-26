//
//  MainScreenBuilder.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 26.08.2025.
//

import UIKit

enum MainScreenBuilder {

    static func build() -> UIViewController {
        let viewController = MainScreenViewController()
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(
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
