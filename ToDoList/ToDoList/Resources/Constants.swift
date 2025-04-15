//
//  Constants.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import UIKit

struct Constants {

    enum Url {
        static let baseUrl = "https://dummyjson.com/"
    }

    enum DateFormatter {
        static let dayMonthCommaHoursMinutes = "dd MMMM, HH:mm"
        static let year = "yyyy"
        static let yearMonthDay = "yyyy-MM-dd"
        static let dayMonthYear = "dd/MM/yy"
    }

    enum Timeouts {
        static let networkRequest = 15.0
    }

    enum LimitsForRequest {
        static let itemsLimit: Int = 5000
        static let limitRequestsPerSecond: Int = 5
    }
}
