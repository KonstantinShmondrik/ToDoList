//
//  RecuestTaskListTest.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import XCTest
@testable import ToDoList

final class RecuestTaskListTests: XCTestCase {

    let delayRequests = 1.0
    private let apiTest = "TasksRequestFactory"


    override func setUpWithError() throws {
        try? super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try? super.tearDownWithError()
    }

    func testGetTaskList() throws {

        let factory = ApiFactory.makeTasksListApi()
        let request = "getTaskList"
        var response: TasksListDTO?
        var error: String?
        let expectation = self.expectation(description: "\(apiTest).\(request) expectation timeout")


        Timer.scheduledTimer(withTimeInterval: self.delayRequests, repeats: false) { _ in
            factory.getList() { data, errorString in
                response = data
                error = errorString
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 15)
        XCTAssertNil(error, "Unexpected \(apiTest).\(request) error \(error ?? "")")
        XCTAssertNotNil(response, "Unexpected \(apiTest).\(request) nil result")
    }
}
