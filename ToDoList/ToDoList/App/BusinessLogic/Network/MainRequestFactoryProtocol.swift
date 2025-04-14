//
//  MainRequestFactoryProtocol.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

protocol MainRequestFactoryProtocol {

    var delegate: (AbstractRequestFactory<MainApi>)? { get }

    func getList(completion: @escaping (_ response: TasksListDTO?, _ error: String?) -> Void)
}

extension MainRequestFactoryProtocol {

    func getList(completion: @escaping (_ response: TasksListDTO?, _ error: String?) -> Void) {
        delegate?.getResponse(
            type: TasksListDTO.self,
            endPoint: .getList,
            completion: completion
        )
    }
}

final class MainRequestFactory: MainRequestFactoryProtocol {

    let delegate: (AbstractRequestFactory<MainApi>)?

    init() {
        delegate = AbstractRequestFactory<MainApi>()
    }
}
