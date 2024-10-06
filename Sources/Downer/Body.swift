public struct Body: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = [Row.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        elements.description(format)
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        elements = description.elements
    }
}
