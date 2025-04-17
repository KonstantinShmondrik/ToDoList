//
//  JSONParameterEncoder.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

// MARK: - JSONParameterEncoder

struct JSONParameterEncoder: ParameterEncoder {

    // MARK: - ParameterEncoder protocol implementation

    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: HttpConstants.contentType) == nil {
                urlRequest.setValue(
                    HttpConstants.jsonContent,
                    forHTTPHeaderField: HttpConstants.contentType
                )
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
