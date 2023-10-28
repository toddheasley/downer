import SwiftUI

public struct Stylesheet: CustomStringConvertible {
    public static let webkit: Self = Self("WebKit Default", description: "")
    public static let `default`: Self = .default(.default)
    
    public static func `default`(_ padding: EdgeInsets) -> Self {
        return Self("Downer Default", description: _description(padding: padding))
    }
    
    public let name: String
    
    public init(_ name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    // MARK: CustomStringConvertible
    public let description: String
}

private func _description(padding: EdgeInsets = .default) -> String { """
:root {
    -webkit-text-size-adjust: none;
    color-scheme: light dark;
}

* {
    margin: 0;
}

a:link {
    cursor: pointer;
}

body {
    color: -apple-system-label;
    font-family: -apple-system;
    font: -apple-system-body;
}

code {
    background: -apple-system-quaternary-label;
    border-radius: 6px;
    padding: 3px 6px 2px 6px;
}

h1, h2, h3, h4, h5, h6, hr, ol, p, pre, table, ul {
    margin-bottom: \(padding.bottom.styleValue);
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
    color: -apple-system-placeholder-text;
}
""" }
