import UniformTypeIdentifiers

public enum Format: Sendable, CaseIterable, CustomStringConvertible {
    case hypertext(_ autolink: [Autolink]), markdown
    
    public static let hypertext: Self = .hypertext([])
    
    public var contentType: UTType {
        switch self {
        case .hypertext:
            return .hypertext
        case .markdown:
            return .markdown
        }
    }
    
    public init?(contentType: UTType) {
        switch contentType {
        case .hypertext:
            self = .hypertext
        case .markdown:
            self = .markdown
        default:
            return nil
        }
    }
    
    // MARK: CaseIterable
    public static let allCases: [Self] = [.hypertext, .markdown]
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .hypertext:
            return "hypertext"
        case .markdown:
            return "markdown"
        }
    }
}

extension UTType {
    public static let markdown: Self = Self(filenameExtension: "md", conformingTo: .text)!
    public static let hypertext: Self = .html
}
