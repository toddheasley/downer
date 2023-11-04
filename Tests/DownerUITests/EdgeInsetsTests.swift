import XCTest
@testable import DownerUI
import SwiftUI

final class EdgeInsetsTests: XCTestCase {
    
}

extension EdgeInsetsTests {
    
    // MARK: StyleConvertible
    func testStyleDescription() {
        XCTAssertEqual(EdgeInsets(24.0).styleDescription, "24px")
        XCTAssertEqual(EdgeInsets(11.0, 8.0, 10.5, -6.25).styleDescription, "11px -6.25px 10.5px 8px")
        XCTAssertEqual(EdgeInsets(11.0, 8.5, 11.0, 8.5).styleDescription, "11px 8.5px")
        XCTAssertEqual(EdgeInsets().styleDescription, "0")
    }
}

final class CGFloatTests: XCTestCase {
    
}

extension CGFloatTests {
    
    // MARK: StyleConvertible
    func testStyleDescription() {
        XCTAssertEqual(CGFloat(43.667).styleDescription, "43.667px")
        XCTAssertEqual(CGFloat(-20.0).styleDescription, "-20px")
        XCTAssertEqual(CGFloat(0.0).styleDescription, "0")
    }
}
