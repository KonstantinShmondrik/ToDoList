//
//  Locale+Extension.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

extension Locale {

    static var preferredLanguage: String {
        let language = Locale.preferredLanguages.first ?? "en"
        return language
    }
}
