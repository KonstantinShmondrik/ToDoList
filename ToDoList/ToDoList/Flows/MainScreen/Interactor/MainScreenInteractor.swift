//
//  MainScreenInteractor.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

class MainScreenInteractor {

    weak var output: MainScreenInteractorOutput?

    private var items: [TaskItem] = []

    private let userRatesApiFactory = ApiFactory.makeTasksListApi()
    private lazy var coreDataService = CommonStore.shared.tasksListCoreDataService


    private func getList() {
        let sortByDate = NSSortDescriptor(key: "createdAt", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        let sortDescriptors = [sortByDate, sortByTitle]

        let fetchAndDisplay: () -> Void = {
            let documents: [TaskListLocal]? = try? self.coreDataService.all(sortDescriptors: sortDescriptors)
            self.items = documents?.compactMap(self.convert) ?? []
            self.output?.setData(self.items)
        }

        if Globals.isFirstTimeEnter != true {
            self.userRatesApiFactory.getList { data, errorMessage in
                guard let data else {
                    self.output?.setAlert(
                        title: Texts.AlertMessage.error,
                        message: errorMessage ?? Texts.ErrorMessage.general
                    )
                    return
                }
                self.setLocalItems(data.todos) {
                    Globals.isFirstTimeEnter = true
                    fetchAndDisplay()
                }
            }
        } else {
            fetchAndDisplay()
        }
    }

    private func setLocalItems(_ items: [Todo], completion: @escaping () -> Void) {
        let group = DispatchGroup()

        items.forEach { item in
            group.enter()
            self.createLocalItem(item) { _ in
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }

    private func createLocalItem(_ item: Todo, completion: @escaping (TaskListLocal) -> Void) {
        coreDataService.create(isSaveRequired: true) { (object: TaskListLocal) in
            object.id = Int32(item.id)
            object.title = item.title ?? "\(item.id) Задача"
            object.todo = item.todo
            object.isCompleted = item.completed
            object.userID = Int32(item.userID)
            object.createdAt = Date.now
            completion(object)
        }
    }

    private func convert(_ item: TaskListLocal) -> TaskItem? {
        return TaskItem(
            id: Int(item.id),
            title: item.title ?? "\(item.id) Задача",
            description: item.todo ?? "",
            isCompleted: item.isCompleted,
            userID: Int(item.userID),
            createdAt: item.createdAtFarmat
        )
    }
}

extension MainScreenInteractor: MainScreenInteractorInput {

    func getData() {
        getList()
    }
}
