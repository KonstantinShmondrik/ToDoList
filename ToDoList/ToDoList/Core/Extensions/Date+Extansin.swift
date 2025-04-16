//
//  Date+Extansin.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import Foundation

extension Date {
    private static let dayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormatter.dayMonthYear
        return formatter
    }()

    var formattedAsDayMonthYear: String {
        return Date.dayMonthYearFormatter.string(from: self)
    }
}

