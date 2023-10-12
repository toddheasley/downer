import Foundation

public struct SoftBreak: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        return " "
    }
    
    public init?(_ description: String) {
        guard let _: Description = Self.parse(description) else {
            return nil
        }
    }
}
