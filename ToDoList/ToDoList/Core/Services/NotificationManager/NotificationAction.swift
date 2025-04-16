//
//  NotificationAction.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//


import UIKit

class NotificationAction: RawRepresentable, Equatable {
    
    typealias RawValue = String
    
    let rawValue: RawValue
    var name: Notification.Name { .init(rawValue: rawValue) }
    
    required init(rawValue: String = #function) {
        self.rawValue = rawValue
    }
    
    convenience init(name: Notification.Name) {
        self.init(rawValue: name.rawValue)
    }
}

extension NotificationAction {
    
    static var keyboardWillShow: NotificationAction { .init(name: UIResponder.keyboardWillShowNotification) }
    static var keyboardWillHide: NotificationAction { .init(name: UIResponder.keyboardWillHideNotification) }
   
}
