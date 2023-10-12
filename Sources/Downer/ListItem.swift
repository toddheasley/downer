public struct ListItem: Element {
    public let checkbox: Bool?
    
    // MARK: Element
    public static let elements: [Element.Type] = [Paragraph.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        switch format {
        case .markdown:
            return "* \(checkbox != nil ? (checkbox! ? "[x] " : "[ ] ") : "")\(description)\n"
        case .hypertext:
            guard let checkbox: Bool = checkbox else {
                return "    <li>\(description)</li>\n"
            }
            return "    <li><input type=\"checkbox\" disabled\(checkbox ? " checked" : "")> \(description)</li>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description),
        let elements: [Element] = description.elements.first?.elements else {
            return nil
        }
        let attributes: [String] = description.attributes.components(separatedBy: "checkbox: ")
        switch attributes.last {
        case "[x]":
            checkbox = true
        case "[ ]":
            checkbox = false
        default:
            checkbox = nil
        }
        self.elements = elements
    }
}
