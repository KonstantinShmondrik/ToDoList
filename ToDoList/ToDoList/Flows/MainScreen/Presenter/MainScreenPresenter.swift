//
//  MainScreenPresenter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

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

    func getData() {
        interactor.getData()
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
