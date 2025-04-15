//
//  MainScreenRouter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

class MainScreenRouter {

    private weak var view: MainScreenViewInput?

    func compose() -> UIViewController {
        let viewController = MainScreenViewController()
        self.view = viewController

        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter(view: viewController, interactor: interactor, router: self)

        interactor.output = presenter
        viewController.presenter = presenter

        viewController.title = "Задачи"
        viewController.navigationItem.largeTitleDisplayMode = .always

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: AppColor.white
        ]

        navigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: AppColor.white
        ]

        return navigationController
    }

}

extension MainScreenRouter: MainScreenRouterInput {

}
