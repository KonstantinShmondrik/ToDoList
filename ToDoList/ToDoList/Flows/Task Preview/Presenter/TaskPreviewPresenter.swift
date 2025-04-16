//
//  TaskPreviewPresenter.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

class TaskPreviewPresenter {

    weak var view: TaskPreviewViewInput?
    let interactor: TaskPreviewInteractorInput
    let router: TaskPreviewRouterInput

    init(view: TaskPreviewViewInput, interactor: TaskPreviewInteractorInput, router: TaskPreviewRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TaskPreviewPresenter: TaskPreviewPresenterInput {


}

extension TaskPreviewPresenter: TaskPreviewInteractorOutput {

}
