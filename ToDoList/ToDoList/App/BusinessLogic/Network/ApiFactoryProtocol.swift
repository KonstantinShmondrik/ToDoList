//
//  ApiFactoryProtocol.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

protocol ApiFactoryProtocol {

    static func makeTasksListApi() -> MainRequestFactoryProtocol
}

final class ApiFactory: ApiFactoryProtocol {

    static func makeTasksListApi() -> MainRequestFactoryProtocol { MainRequestFactory() }
}
