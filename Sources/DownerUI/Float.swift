import SwiftUI
import Foundation

extension Float {
    var rgbValue: Int {
        return Int((255.0 * min(max(self, 0.0), 1.0)).rounded())
    }
}

extension CGFloat: StyleRepresentable {
    
    // StyleRepresentable
    var styleValue: String {
        return self == 0.0 ? "0" : "\(self)px".replacingOccurrences(of: ".0p", with: "p")
    }
}
