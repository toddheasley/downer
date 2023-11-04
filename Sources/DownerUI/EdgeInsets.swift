import SwiftUI

extension EdgeInsets: StyleConvertible {
    static var `default`: Self {
#if os(macOS)
        return Self(8.0, 10.0, 8.0, 11.0)
#else
        return Self(8.0, 8.0, 24.0, 8.0)
#endif
    }
    
    static var toolbar: Self {
        return Self(8.0, Self.default.leading, 8.0, Self.default.trailing)
    }
    
    static var popover: Self {
        return Self(11.0)
    }
    
    init(_ top: CGFloat = 0.0, _ leading: CGFloat = 0.0, _ bottom: CGFloat = 0.0, _ trailing: CGFloat = 0.0) {
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    init(_ all: CGFloat) {
        self.init(all, all, all, all)
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
    
    // MARK: StyleConvertible
    var styleDescription: String {
        return self == 0.0 ? "0" : "\(self)px".replacingOccurrences(of: ".0p", with: "p")
    }
}
