//
//  Welcome.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

struct TasksListDTO: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
