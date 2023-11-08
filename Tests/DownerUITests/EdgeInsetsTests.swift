import XCTest
@testable import DownerUI
import SwiftUI

final class EdgeInsetsTests: XCTestCase {
    
}

extension EdgeInsetsTests {
    
    // MARK: StyleConvertible
    func testStyleDescription() {
        XCTAssertEqual(EdgeInsets(top: 24.0, leading: 24.0, bottom: 24.0, trailing: 24.0).styleDescription, "24px")
        XCTAssertEqual(EdgeInsets(top: 11.0, leading: 8.0, bottom: 10.5, trailing: -6.25).styleDescription, "11px -6.25px 10.5px 8px")
        XCTAssertEqual(EdgeInsets(top: 11.0, leading: 8.5, bottom: 11.0, trailing: 8.5).styleDescription, "11px 8.5px")
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
