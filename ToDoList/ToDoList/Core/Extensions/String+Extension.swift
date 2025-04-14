//
//  String+Extension.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import UIKit
import CommonCrypto

extension String {

    var localized: String {
        let language = Locale.preferredLanguage

        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
}
