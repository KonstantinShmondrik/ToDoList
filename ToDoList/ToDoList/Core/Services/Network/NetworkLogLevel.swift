//
//  NetworkLogLevel.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

enum NetworkLogLevel {
    case none
    case error
    case info
    case debug
}

struct NetworkLogger {
    static var logLevel: NetworkLogLevel = .debug

    static func logRequest(_ request: URLRequest) {
        guard logLevel == .debug || logLevel == .info else { return }

        print("\n---------- 🌐 REQUEST ----------")
        if let method = request.httpMethod, let url = request.url {
            print("➡️ \(method) \(url.absoluteString)")
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("🧾 Headers:")
            headers.forEach { print("  \($0.key): \($0.value)") }
        }

        if let body = request.httpBody,
           let json = try? JSONSerialization.jsonObject(with: body, options: .mutableContainers),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let bodyString = String(data: pretty, encoding: .utf8) {
            print("📦 Body:\n\(bodyString)")
        }

        print("-------------------------------\n")
    }

    static func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard logLevel != .none else { return }

        print("\n---------- 📬 RESPONSE ----------")

        if let httpResponse = response as? HTTPURLResponse {
            print("✅ Status code: \(httpResponse.statusCode)")
            print("🔗 URL: \(httpResponse.url?.absoluteString ?? "")")
        }

        if let error = error {
            print("❌ Error: \(error.localizedDescription)")
        }

        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let responseString = String(data: pretty, encoding: .utf8) {
            print("📨 Response:\n\(responseString)")
        } else if let data = data, let raw = String(data: data, encoding: .utf8) {
            print("📨 Raw response:\n\(raw)")
        }

        print("-------------------------------\n")
    }
}
