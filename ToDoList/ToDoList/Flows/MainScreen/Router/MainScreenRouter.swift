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

    func makePreviewViewController(for item: TaskItem) -> UIViewController {
        let router = TaskPreviewRouter(item: item)
        let vc = router.compose()

        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIView.layoutFittingCompressedSize.height)
        let calculatedSize = vc.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        vc.preferredContentSize = calculatedSize
        return vc
    }

    func makeContextMenuActions(for item: TaskItem) -> UIMenu {
        let edit = UIAction(title: "Редактировать", image: UIImage(resource: .edit)) { _ in
            self.goToTaskDitails(for: item)
        }

        let export = UIAction(title: "Поделиться", image: UIImage(resource: .export)) { _ in
            self.view?.exportItem(item)
        }

        let delete = UIAction(title: "Удалить", image: UIImage(resource: .trash), attributes: .destructive) { _ in
            self.view?.deleteItem(item)
        }

        return UIMenu(title: "", children: [edit, export, delete])
    }

    func createNewTask() {
        let router = TaskDetailsRouter()
        let vc = router.compose(for: nil)
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func goToTaskDitails(for item: TaskItem) {
        let router = TaskDetailsRouter()
        let vc = router.compose(for: item)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
