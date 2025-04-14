//
//  MainApi.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

// MARK: - UserRatesApi

enum MainApi {
    case getList
}

// MARK: EndPointType

extension MainApi: EndPointType {

    var headers: HTTPHeaders? { nil }

    var path: String { "todos" }

    var httpMethod: HTTPMethod { .get }

    var task: HTTPTask {
        .requestParametersAndHeaders(
            bodyParameters: nil,
            bodyEncoding: .urlEncoding,
            urlParameters: nil,
            additionHeaders: headers
        )
    }
}
