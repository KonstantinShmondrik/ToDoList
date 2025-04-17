//
//  Globals.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

struct Globals {

    @UserDefault(UserDefaultsKeys.isFirstTimeEnter.rawValue)
    static var isFirstTimeEnter: Bool?
}
