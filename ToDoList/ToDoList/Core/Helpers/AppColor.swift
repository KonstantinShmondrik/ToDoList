//
//  AppColor.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import UIKit

enum AppColor {

    private static let missingColor: UIColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

    static let subText = UIColor(named: "subText") ?? missingColor
    static let white = UIColor(named: "white") ?? missingColor
    static let gray = UIColor(named: "gray") ?? missingColor
    static let stroke = UIColor(named: "stroke") ?? missingColor
    static let yellow = UIColor(named: "yellow") ?? missingColor
}
