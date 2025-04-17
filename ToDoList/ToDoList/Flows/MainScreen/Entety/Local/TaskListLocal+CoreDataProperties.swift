//
//  TaskListLocal+CoreDataProperties.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 17.04.2025.
//
//

import Foundation
import CoreData


extension TaskListLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskListLocal> {
        return NSFetchRequest<TaskListLocal>(entityName: "TaskListLocal")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var userID: Int32

}

extension TaskListLocal : Identifiable {

}

extension TaskListLocal {

    var createdAtFarmat: String? {
        guard let createdAt = createdAt else { return nil }
        return createdAt.formattedAsDayMonthYear
    }
}
