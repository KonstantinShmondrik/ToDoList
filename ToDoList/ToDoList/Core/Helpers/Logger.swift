//
//  Logger.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

enum LogLevel: String {
    case debug = "🐞 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
}

struct Logger {
    static var isEnabled: Bool = true
    static var logLevel: LogLevel = .debug

    static func log(_ message: String, level: LogLevel = .debug, file: String = #file, function: String = #function, line: Int = #line) {
        guard isEnabled else { return }

        let fileName = (file as NSString).lastPathComponent
        print("==================================================\n\n[\(level.rawValue)] \(fileName):\(line) \(function)\n\n\(message)\n\n==================================================")
    }
}
