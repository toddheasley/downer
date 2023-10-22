import SwiftUI

public struct Stylesheet: CustomStringConvertible {
    public static let `default`: Self = Self("Downer Default", description: defaultDescription())
    public static let webkit: Self = Self("WebKit Default", description: "")
    
    public let name: String
    
    public init(_ name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    // MARK: CustomStringConvertible
    public let description: String
}

protocol StyleRepresentable {
    var styleValue: String { get }
    init?(style value: String)
}

extension StyleRepresentable {
    init?(style value: String) {
        fatalError("init(style:) has not been implemented")
    }
}

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

extension CGFloat: StyleRepresentable {
    
    // StyleRepresentable
    var styleValue: String {
        return self == 0.0 ? "0" : "\(self)px".replacingOccurrences(of: ".0p", with: "p")
    }
}

private func defaultDescription(padding: EdgeInsets = .default) -> String { """
:root {
    -webkit-text-size-adjust: none;
    color-scheme: light dark;
}

* {
    margin: 0;
}

a {
    /* color: -apple-system-red; */
}

body {
    font-family: -apple-system;
    font: -apple-system-body;
}

img {
    max-width: 100%;
}

#editor {
    min-height: calc(100vh - \((padding.top + padding.bottom).styleValue));
}

#editor, #placeholder {
    min-width: calc(100vw - \((padding.leading + padding.trailing).styleValue));
    padding: \(padding.styleValue);
    position: absolute;
}

#editor:focus {
    outline: none;
}

#placeholder {
    color: gray;
}
""" }
