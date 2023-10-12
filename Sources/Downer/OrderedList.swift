public struct OrderedList: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = [ListItem.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        switch format {
        case .markdown:
            var count: Int = 0
            let components: [String] = description.components(separatedBy: "\n").map { component in
                count += 1
                return component.hasPrefix("*") ? "\(count).\(component.dropFirst())" : component
            }
            return "\(components.joined(separator: "\n"))\n"
        case .hypertext:
            return "<ol>\n\(description)</ol>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        elements = description.elements
    }
}
