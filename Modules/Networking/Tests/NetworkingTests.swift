import XCTest

@testable import Networking

class NetworkingTests: XCTestCase {
    func test_value() {
        XCTAssertEqual(NetworkingImpl().fetchTitle(), "My Title")
    }

    func test_fix_value() {
        XCTAssertEqual(50, 50)
    }
}
