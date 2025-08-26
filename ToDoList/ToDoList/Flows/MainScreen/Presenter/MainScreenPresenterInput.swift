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
    func makeContextMenu(for item: TaskItem) -> UIMenu
    func deleteItem(_ item: TaskItem)
    func completeItem(_ item: TaskItem)
    func createNewTask()
    func didSelectTask(_ task: TaskItem)
    func findTask(containing text: String)
}
