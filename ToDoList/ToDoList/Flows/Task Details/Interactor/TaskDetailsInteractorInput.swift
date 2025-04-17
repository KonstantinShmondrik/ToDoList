//
//  TaskDetailsInteractorInput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

protocol TaskDetailsInteractorInput: AnyObject {

    func generateNewTaskID() -> Int
    func updateItem(_ item: TaskItem, completion: (() -> Void)?)
    func createItem(_ item: TaskItem, completion: (() -> Void)?)
}
