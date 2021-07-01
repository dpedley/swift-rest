import XCTest
import SwiftUI
import Combine

@testable import swift_rest

struct MockPerson: Codable {
    var name: String
    let age: Int
    let living: Bool
}

final class AsyncRestRequestTests: XCTestCase {
    func testMockPerson() throws {
        let waitForGet = expectation(description: "waitForGet")
        var optionalPerson: MockPerson?
        let boundPerson = Binding<MockPerson?>(
            get: {
            optionalPerson
        },
            set: { mockPerson, _ in
            waitForGet.fulfill()
            optionalPerson = mockPerson
        })
        let aPerson = MockPerson(name: "Doug", age: 50, living: true)
        let api = AsyncRestRequest()
                    .mock(response: aPerson)
                    .bind(success: boundPerson)
        _ = api.get()
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(boundPerson.wrappedValue?.name, "Doug")
    }
}
