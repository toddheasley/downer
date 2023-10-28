import SwiftUI

extension EdgeInsets: StyleRepresentable {
    static var `default`: Self {
#if os(macOS)
        return Self(8.0, 10.0, 8.0, 11.0)
#else
        return Self(8.0)
#endif
    }
    
    init(_ top: CGFloat = 0.0, _ leading: CGFloat = 0.0, _ bottom: CGFloat = 0.0, _ trailing: CGFloat = 0.0) {
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    init(_ all: CGFloat) {
        self.init(all, all, all, all)
    }
    
    // StyleRepresentable
    var styleValue: String {
        let values: [String] = [top, trailing, bottom, leading].map { $0.styleValue }
        if values[0] == values[1], values[0] == values[2], values[0] == values[3] {
            return values[0]
        } else if values[0] == values[2], values[1] == values[3] {
            return values[0...1].joined(separator: " ")
        } else {
            return values.joined(separator: " ")
        }
    }
}
