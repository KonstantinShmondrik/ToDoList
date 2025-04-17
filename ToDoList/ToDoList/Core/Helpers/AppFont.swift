//
//  AppFont.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import UIKit

struct AppFont {

    enum Style {
        /// 16, 500
        static let button = UIFont.systemFont(ofSize: 16, weight: .medium)
        /// 12, 400
        static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
        /// 16, 400
        static let regularTitle = UIFont.systemFont(ofSize: 16, weight: .regular)
        /// 34, 700
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    }
}
