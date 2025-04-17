//
//  NotificationManagerDelegate.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//


import Foundation

protocol NotificationManagerDelegate: AnyObject {

    func performOnTrigger(_ notification: NotificationAction, object: Any?, userInfo: [AnyHashable: Any]?)
}

class NotificationManager {

    private let notificationCenter = NotificationCenter.default
    weak var delegate: NotificationManagerDelegate?

    func subscribe(to notification: NotificationAction, object: Any? = nil) {
        notificationCenter.addObserver(self, selector: #selector(selector), name: notification.name, object: object)
    }

    func unsubscribe(from notification: NotificationAction, object: Any? = nil) {
        notificationCenter.removeObserver(self, name: notification.name, object: object)
    }

    func trigger(notification: NotificationAction, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        notificationCenter.post(name: notification.name, object: object, userInfo: userInfo)
    }

    @objc private func selector(_ notification: Notification) {
        let baseNotification = NotificationAction(name: notification.name)
        delegate?.performOnTrigger(baseNotification, object: notification.object, userInfo: notification.userInfo)
    }
}