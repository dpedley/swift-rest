import XCTest
import SwiftUI
import Combine

@testable import SwiftRest

struct MockPerson: Codable {
    var name: String
    let age: Int
    let living: Bool
}

final class AsyncRestRequestTests: XCTestCase {
    func testMockStatusCode() throws {
        let waitForGet = expectation(description: "waitForGet")
        var responseCode: Int?
        let boundCode = Binding<Int?>(
            get: {
            responseCode
        },
            set: { statusCode, _ in
            waitForGet.fulfill()
            responseCode = statusCode
        })
        let api = AsyncRestRequest()
                    .mock(response: 200)
                    .bind(statusCode: boundCode)
        _ = api.get()
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(responseCode, 200)
    }
    
    func testMockPersonResponse() throws {
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
        XCTAssertEqual(boundPerson.wrappedValue?.age, 50)
    }
    
    func testMockPersonPOST() throws {
        let waitForPost = expectation(description: "waitForPost")
        var optionalPerson: MockPerson?
        let boundPerson = Binding<MockPerson?>(
            get: {
            optionalPerson
        },
            set: { mockPerson, _ in
            waitForPost.fulfill()
            optionalPerson = mockPerson
        })
        let aPerson = MockPerson(name: "Mary", age: 30, living: true)
        let api = AsyncRestRequest()
                    .bind(success: boundPerson)
        _ = api.post(body: aPerson, mockResponse: true)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(boundPerson.wrappedValue?.name, "Mary")
        XCTAssertEqual(boundPerson.wrappedValue?.age, 30)
    }
    
    func testHeaders() throws {
        let api = AsyncRestRequest().withHeaders([
            "first" : 1,
            "second" : "two"
        ])
        let request = api.buildRequest(url: URL(fileURLWithPath: "/"))
        let one = try XCTUnwrap(request.value(forHTTPHeaderField: "first"))
        let two = try XCTUnwrap(request.value(forHTTPHeaderField: "second"))
        XCTAssertEqual(one, "1")
        XCTAssertEqual(two, "two")
    }
}
