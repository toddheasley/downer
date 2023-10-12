public struct Cell: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = [Emphasis.self, Image.self, InlineCode.self, LineBreak.self, Link.self, SoftBreak.self, Strikethrough.self, Strong.self, Text.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        switch format {
        case .markdown:
            return "| \(description) "
        case .hypertext:
            return "        <td>\(description)</td>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        elements = description.elements
    }
}
