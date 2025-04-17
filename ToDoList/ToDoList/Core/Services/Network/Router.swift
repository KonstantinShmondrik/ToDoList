//
//  protocol.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

// MARK: - NetworkRouter protocol

protocol NetworkRouter {

    associatedtype EndPoint: EndPointType

    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

final class Router<EndPoint: EndPointType>: NetworkRouter {

    // MARK: - Private properties

    private let queue: OperationQueue
    private var task: URLSessionTask?

    // MARK: - Construction

    init() {
        queue = OperationQueue()
        queue.qualityOfService = .utility
    }

    // MARK: - Functions

    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let backgroundQueue = DispatchQueue.global(qos: .utility)
        backgroundQueue.async {
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: self.queue)

            if Thread.isMainThread {
                Logger.log("Request is being made on the main thread.", level: .warning)
            } else {
                Logger.log("Request is being made on a background thread.", level: .info)
            }

            do {
                let request = try self.buildRequest(from: route)

                NetworkLogger.logRequest(request)

                self.task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if Thread.isMainThread {
                        Logger.log("Request is being made on the main thread.", level: .warning)
                    } else {
                        Logger.log("Request is being made on a background thread.", level: .info)
                    }

                    NetworkLogger.logResponse(data: data, response: response, error: error)

                    completion(data, response, error)
                })
            } catch {
                completion(nil, nil, error)
            }
            self.task?.resume()
        }
    }

    func cancel() {
        self.task?.cancel()
    }

    // MARK: - Private functions

    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: EndPoint.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue(
                    HttpConstants.jsonContent,
                    forHTTPHeaderField: HttpConstants.contentType
                )
            case .requestParameters(
                let bodyParameters,
                let bodyEncoding,
                let urlParameters
            ):
                try self.configureParameters(
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request
                )
            case .requestParametersAndHeaders(
                let bodyParameters,
                let bodyEncoding,
                let urlParameters,
                let additionalHeaders
            ): 
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request
                )
            }
            return request
        } catch {
            throw error
        }
    }

    private func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(
                urlRequest: &request,
                bodyParameters: bodyParameters,
                urlParameters: urlParameters
            )
        } catch {
            throw error
        }
    }

    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
