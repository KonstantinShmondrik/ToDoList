//
//  MainScreenPresenter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

final class MainScreenPresenter {

    weak var view: MainScreenViewInput?
    let interactor: MainScreenInteractorInput
    let router: MainScreenRouterInput

    init(view: MainScreenViewInput, interactor: MainScreenInteractorInput, router: MainScreenRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    private func didSelectContextMenuAction(_ action: ContextMenuAction) {
        switch action {
        case .edit(let task):
            router.goToTaskDetails(for: task)
        case .export(let task):
            view?.exportItem(task)
        case .delete(let task):
            view?.deleteItem(task)
        }
    }
}

extension MainScreenPresenter: MainScreenPresenterInput {

    func completeItem(_ item: TaskItem) {
        interactor.completeItem(item)
    }

    func deleteItem(_ item: TaskItem) {
        interactor.deleteItem(item)
    }

    func getData() {
        interactor.getData()
    }

    func makePreviewViewController(for item: TaskItem) -> UIViewController {
        let vc = router.makePreviewViewController(for: item)
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIView.layoutFittingCompressedSize.height)
        let calculatedSize = vc.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        vc.preferredContentSize = calculatedSize
        return vc
    }

    func makeContextMenu(for item: TaskItem) -> UIMenu {
        return router.makeContextMenuActions(for: item) { [weak self] action in
            self?.didSelectContextMenuAction(action)
        }
    }

    func createNewTask() {
        router.createNewTask()
    }

    func didSelectTask(_ task: TaskItem) {
        router.goToTaskDetails(for: task)
    }

    func findTask(containing text: String) {
        interactor.findTask(containing: text)
    }
}

extension MainScreenPresenter: MainScreenInteractorOutput {

    func setAlert(title: String, message: String?) {
        view?.setAlert(title: title, message: message)
    }

    func setData(_ items: [TaskItem]) {
        view?.setData(items)
    }
}
