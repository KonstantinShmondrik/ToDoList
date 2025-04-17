//
//  CoreDataServiceTests.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//


import XCTest
import CoreData
@testable import ToDoList

final class CoreDataServiceTests: XCTestCase {

    var sut: CoreDataService!

        override func setUpWithError() throws {
            try super.setUpWithError()
            sut = TestCoreDataService()
        }

        override func tearDownWithError() throws {
            sut = nil
            try super.tearDownWithError()
        }

    func testCreateEntity() throws {
        // when
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in
            task.title = "Test Task"
        }

        // then
        let results: [TestLocalEntity] = try sut.all()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Test Task")
    }

    func testFetchWithPredicate() throws {
        // given
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in
            task.title = "Important"
        }
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in
            task.title = "Not Important"
        }

        // when
        let predicate = NSPredicate(format: "title == %@", "Important")
        let result: TestLocalEntity? = try sut.object(with: predicate)

        // then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.title, "Important")
    }

    func testUpdateEntity() throws {
        // given
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in
            task.title = "Old Title"
        }

        let predicate = NSPredicate(format: "title == %@", "Old Title")

        // when
        try sut.update(with: predicate) { (task: TestLocalEntity) in
            task.title = "New Title"
        }

        // then
        let updatedPredicate = NSPredicate(format: "title == %@", "New Title")
        let updatedTask: TestLocalEntity? = try sut.object(with: updatedPredicate)
        XCTAssertNotNil(updatedTask)
        XCTAssertEqual(updatedTask?.title, "New Title")
    }

    func testDeleteEntity() throws {
        // given
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in
            task.title = "To be deleted"
        }

        let predicate = NSPredicate(format: "title == %@", "To be deleted")
        guard let task: TestLocalEntity = try sut.object(with: predicate) else {
            XCTFail("Object not found")
            return
        }

        // when
        sut.delete(object: task)

        // then
        let deleted: TestLocalEntity? = try sut.object(with: predicate)
        XCTAssertNil(deleted)
    }

    func testDeleteAll() throws {
        // given
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in task.title = "1" }
        sut.create(isSaveRequired: true) { (task: TestLocalEntity) in task.title = "2" }

        // when
        try sut.deleteAll(type: TestLocalEntity.self)

        // then
        let tasks: [TestLocalEntity] = try sut.all()
        XCTAssertTrue(tasks.isEmpty)
    }
}
