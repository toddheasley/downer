import XCTest
@testable import DownerUI
import SwiftUI

final class EdgeInsetsTests: XCTestCase {
    
}

extension EdgeInsetsTests {
    
    // MARK: StyleRepresentable
    func testStyleValue() {
        XCTAssertEqual(EdgeInsets(24.0).styleValue, "24px")
        XCTAssertEqual(EdgeInsets(11.0, 8.0, 10.5, -6.25).styleValue, "11px -6.25px 10.5px 8px")
        XCTAssertEqual(EdgeInsets(11.0, 8.5, 11.0, 8.5).styleValue, "11px 8.5px")
        XCTAssertEqual(EdgeInsets().styleValue, "0")
    }
}

final class CGFloatTests: XCTestCase {
    
}

extension CGFloatTests {
    
    // MARK: StyleRepresentable
    func testStyleValue() {
        XCTAssertEqual(CGFloat(43.667).styleValue, "43.667px")
        XCTAssertEqual(CGFloat(-20.0).styleValue, "-20px")
        XCTAssertEqual(CGFloat(0.0).styleValue, "0")
    }
}
