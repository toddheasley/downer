import XCTest
@testable import DownerUI
import SwiftUI

final class FloatTests: XCTestCase {
    
}

extension FloatTests {
    func testRGBValue() {
        XCTAssertEqual(Float(-1.0).rgbValue, 0)
        XCTAssertEqual(Float(255.0).rgbValue, 255)
        XCTAssertEqual(Float(1.0).rgbValue, 255)
        XCTAssertEqual(Float(0.15).rgbValue, 38)
        XCTAssertEqual(Float(0.875).rgbValue, 223)
        XCTAssertEqual(Float(0.5).rgbValue, 128)
        XCTAssertEqual(Float(0.0).rgbValue, 0)
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
