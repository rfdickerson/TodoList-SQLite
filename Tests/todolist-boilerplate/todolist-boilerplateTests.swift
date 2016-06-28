import XCTest
@testable import todolist-boilerplate

class todolist-boilerplateTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(todolist-boilerplate().text, "Hello, World!")
    }


    static var allTests : [(String, (todolist-boilerplateTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
