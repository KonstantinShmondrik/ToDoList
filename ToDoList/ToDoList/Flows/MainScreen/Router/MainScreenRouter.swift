//
//  MainScreenRouter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

final class MainScreenRouter {

    weak var view: MainScreenViewInput?
}

extension MainScreenRouter: MainScreenRouterInput {

    func makePreviewViewController(for item: TaskItem) -> UIViewController {
        return TaskPreviewBuilder.build(item: item)
    }

    func makeContextMenuActions(for item: TaskItem, handler: @escaping (ContextMenuAction) -> Void) -> UIMenu {
        let edit = UIAction(title: Texts.LocalTexts.edit, image: UIImage(resource: .edit)) { _ in
            handler(.edit(item))
        }

        let export = UIAction(title: Texts.LocalTexts.share, image: UIImage(resource: .export)) { _ in
            handler(.export(item))
        }

        let delete = UIAction(title: Texts.LocalTexts.delete, image: UIImage(resource: .trash), attributes: .destructive) { _ in
            handler(.delete(item))
        }

        return UIMenu(title: "", children: [edit, export, delete])
    }

    func createNewTask() {
        let vc = TaskDetailsBuilder.build(task: nil)
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func goToTaskDetails(for item: TaskItem) {
        let vc = TaskDetailsBuilder.build(task: item)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
