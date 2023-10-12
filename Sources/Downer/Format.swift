import UniformTypeIdentifiers

public enum Format: String, CaseIterable, CustomStringConvertible {
    case markdown, hypertext
    
    public var contentType: UTType {
        switch self {
        case .markdown:
            return .markdown
        case .hypertext:
            return .hypertext
        }
    }
    
    public init?(contentType: UTType) {
        switch contentType {
        case .markdown:
            self = .markdown
        case .hypertext:
            self = .hypertext
        default:
            return nil
        }
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        return rawValue
    }
}

extension UTType {
    public static let markdown: Self = Self(filenameExtension: "md", conformingTo: .text)!
    public static let hypertext: Self = .html
}
