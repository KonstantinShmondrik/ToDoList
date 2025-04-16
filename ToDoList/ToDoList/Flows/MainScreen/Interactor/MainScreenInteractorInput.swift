//
//  MainScreenInteractorImput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

protocol MainScreenInteractorInput: AnyObject {

    func getData()
    func deleteItem(_ item: TaskItem)
    func completeItem(_ item: TaskItem)
}
