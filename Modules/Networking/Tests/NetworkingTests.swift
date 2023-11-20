import XCTest

@testable import Networking

class ListTests: XCTestCase {
    func test_value() {
        XCTAssertEqual(NetworkingImpl.fetchTitle(), "My Title")
    }
}
