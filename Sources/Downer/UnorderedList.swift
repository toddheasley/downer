public struct UnorderedList: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = [ListItem.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        switch format {
        case .markdown:
            return "\(description)\n"
        case .hypertext:
            return "<ul>\n\(description)</ul>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        elements = description.elements
    }
}
