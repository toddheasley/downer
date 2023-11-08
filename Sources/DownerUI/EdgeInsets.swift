import SwiftUI

extension EdgeInsets: StyleConvertible {
    static var `default`: Self {
#if os(macOS)
        return Self(top: 8.0, leading: 10.0, bottom: 8.0, trailing: 11.0)
#else
        return Self(top: 8.0, leading: 8.0, bottom: 24.0, trailing: 8.0)
#endif
    }
    
    static var popover: Self {
        return Self(top: 11.0, leading: 11.0, bottom: 11.0, trailing: 11.0)
    }
    
    // MARK: StyleConvertible
    var styleDescription: String {
        let values: [String] = [top, trailing, bottom, leading].map { $0.styleDescription }
        if values[0] == values[1], values[0] == values[2], values[0] == values[3] {
            return values[0]
        } else if values[0] == values[2], values[1] == values[3] {
            return values[0...1].joined(separator: " ")
        } else {
            return values.joined(separator: " ")
        }
    }
}

extension CGFloat: StyleConvertible {
    static let spacing: Self = 8.0
    
    // MARK: StyleConvertible
    var styleDescription: String {
        return self == 0.0 ? "0" : "\(self)px".replacingOccurrences(of: ".0p", with: "p")
    }
}
