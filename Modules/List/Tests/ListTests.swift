import XCTest

@testable import List

class ListTests: XCTestCase {
    func test_value() {
        XCTAssertEqual(ListModel.value, 100)
    }
}
