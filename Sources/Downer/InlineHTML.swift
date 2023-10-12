public struct InlineHTML: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        return description
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        self.description = description.attributes
    }
    
    // MARK: CustomStringConvertible
    public let description: String
}
