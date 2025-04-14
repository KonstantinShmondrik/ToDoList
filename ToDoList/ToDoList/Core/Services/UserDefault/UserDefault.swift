//
//  UserDefault.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import Foundation

@propertyWrapper
struct UserDefault<V: Codable> {

    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: V? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            return try? JSONDecoder().decode(V.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}
