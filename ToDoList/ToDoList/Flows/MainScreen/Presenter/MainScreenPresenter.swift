//
//  MainScreenPresenter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

class MainScreenPresenter {

    weak var view: MainScreenViewInput?
    let interactor: MainScreenInteractorInput
    let router: MainScreenRouterInput

    init(view: MainScreenViewInput, interactor: MainScreenInteractorInput, router: MainScreenRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
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
        router.makePreviewViewController(for: item)
    }
    
    func makeContextMenuActions(for item: TaskItem) -> UIMenu {
        router.makeContextMenuActions(for: item)
    }

    func createNewTask() {
        router.createNewTask()
    }

    func goToTaskDitails(for item: TaskItem) {
        router.goToTaskDitails(for: item)
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
