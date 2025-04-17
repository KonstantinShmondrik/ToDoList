//
//  MainScreenPresenterImput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

protocol MainScreenPresenterInput: AnyObject {

    func getData()
    func makePreviewViewController(for item: TaskItem) -> UIViewController
    func makeContextMenuActions(for item: TaskItem) -> UIMenu

    func deleteItem(_ item: TaskItem)
    func completeItem(_ item: TaskItem)

    func createNewTask()
    func goToTaskDitails(for item: TaskItem)

    func findTask(containing text: String)
}
