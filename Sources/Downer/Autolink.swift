import Foundation

public struct Autolink: Equatable, Sendable, CustomStringConvertible {
    public static let link: Self = Self("Link", "(?<!\")(https?:\\/\\/)([\\w\\-\\.!~?&+\\*'\"(),\\/]+)", "<a href=\"$1$2\">$2</a>")
    public static let email: Self = Self("Email", "(?<!\")(mailto:)([A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4})", "<a href=\"$1$2\">$2</a>")
    
    public let pattern: String
    public let template: String
    
    public init(_ description: String, _ pattern: String, _ template: String) {
        self.description = description
        self.pattern = pattern
        self.template = template
    }
    
    func convert(_ html: HTML) throws -> HTML {
        try NSRegularExpression(pattern: pattern, options: [
            .caseInsensitive
        ]).stringByReplacingMatches(in: html, range: NSMakeRange(0, html.count), withTemplate: template)
    }
    
    // MARK: CustomStringConvertible
    public let description: String
}

extension [Autolink] {
    func convert(_ html: HTML) throws -> String {
        var html: HTML = html
        for autolink in self {
            html = try autolink.convert(html)
        }
        return html
    }
}
