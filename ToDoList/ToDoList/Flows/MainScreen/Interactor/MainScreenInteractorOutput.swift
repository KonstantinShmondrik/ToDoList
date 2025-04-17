//
//  MainScreenInteractorOutput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

protocol MainScreenInteractorOutput: AnyObject {

    func setAlert(title: String, message: String?)
    func setData(_ items: [TaskItem])
}
