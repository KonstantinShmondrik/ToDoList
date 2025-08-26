//
//  MainScreenRouterImput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

protocol MainScreenRouterInput: AnyObject {

    func makePreviewViewController(for item: TaskItem) -> UIViewController
    func makeContextMenuActions(for item: TaskItem, handler: @escaping (ContextMenuAction) -> Void) -> UIMenu
    func createNewTask()
    func goToTaskDetails(for item: TaskItem)
}
