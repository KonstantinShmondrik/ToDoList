//
//  TestLocalEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 17.04.2025.
//
//

import Foundation
import CoreData


extension TestLocalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestLocalEntity> {
        return NSFetchRequest<TestLocalEntity>(entityName: "TestLocalEntity")
    }

    @NSManaged public var title: String?

}

extension TestLocalEntity : Identifiable {

}
