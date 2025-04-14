//
//  enum.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

typealias HTTPHeaders = [String: String]

// MARK: - HTTPTask enum

enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncoding,
                           urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}
