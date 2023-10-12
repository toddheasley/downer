public struct Heading: Element {
    public let level: Int
    
    // MARK: Element
    public static let elements: [Element.Type] = [Emphasis.self, Image.self, InlineCode.self, LineBreak.self, Link.self, SoftBreak.self, Strikethrough.self, Strong.self, Text.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        switch format {
        case .markdown:
            return "\(String(repeating: "#", count: level)) \(description)\n\n"
        case .hypertext:
            return "<h\(level)>\(description)</h\(level)>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        let attributes: [String] = description.attributes.components(separatedBy: "level: ")
        guard attributes.count == 2,
              let level: Int = Int(attributes[1]) else {
            return nil
        }
        self.level = min(max(level, 1), 6)
        elements = description.elements
    }
}
