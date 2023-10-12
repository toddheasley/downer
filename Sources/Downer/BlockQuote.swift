public struct BlockQuote: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = [OrderedList.self, Paragraph.self, ThematicBreak.self, UnorderedList.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let components: [String] = elements.description(format).trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        switch format {
        case .markdown:
            return "\(components.map { $0.isEmpty ? ">" : "> \($0)" }.joined(separator: "\n"))\n\n"
        case .hypertext:
            return "<blockquote>\n\(components.map { "    \($0)" }.joined(separator: "\n"))\n</blockquote>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        elements = description.elements
    }
}
