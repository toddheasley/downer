import Foundation

typealias HTML = String

extension HTML {
    enum Conversion: CaseIterable, Equatable, CustomStringConvertible {
        static let blockQuote: Self = .complex("BlockQuote") { html in
            return html
        }
        
        static let codeBlock: Self = .complex("CodeBlock") { html in
            return html
        }
        
        static let emphasis: Self = .pattern("Emphasis", [
            ("<em.*?>(.*?)</em>", "_$1_"),
            ("<i.*?>(.*?)</i>", "_$1_")
        ])
        
        static let heading: Self = .pattern("Heading", [
            
        ])
        
        static let image: Self = .pattern("Image", [
            
        ])
        
        static let inlineCode: Self = .pattern("InlineCode", [
            
        ])
        
        static let lineBreak: Self = .pattern("LineBreak", [
            ("<br.*?>", "  \n")
        ])
        
        static let link: Self = .pattern("Link", [
            ("<a.*?href=[\"']([^\"']*)[\"'][^>]*>([^<]*)</a>", "[$2]($1)"),
            ("(\\[\\]\\))([^<]*)(\\))", "[$2]()")
        ])
        
        static let paragraph: Self = .pattern("Paragraph", [
            ("<p.*?>(.*?)</p>", "\n$1\n\n"),
        ])
        
        static let strikethrough: Self = .pattern("Strikethrough", [
            ("<del.*?>(.*?)</del>", "~~$1~~"),
        ])
        
        static let strong: Self = .pattern("Strong", [
            ("<strong.*?>(.*?)</strong>", "__$1__"),
            ("<b.*?>(.*?)</b>", "__$1__")
        ])
        
        static let thematicBreak: Self = .pattern("ThematicBreak", [
            ("<hr.*?>", "\n-----\n\n")
        ])
        
        typealias Pattern = (String, template: String)
        typealias Handler = (String) -> String
        
        case pattern(_ name: String, _ patterns: [Pattern])
        case complex(_ name: String, handler: Handler)
        
        var name: String {
            switch self {
            case .pattern(let name, _), .complex(let name, _):
                return name
            }
        }
        
        func convert(_ html: HTML) throws -> String {
            switch self {
            case .pattern(_, let patterns):
                var html: HTML = html
                for pattern in patterns {
                    html = (try NSRegularExpression(pattern: pattern.0, options: .caseInsensitive)).stringByReplacingMatches(in: html, options: [], range: NSMakeRange(0, html.count), withTemplate: pattern.template)
                }
                return html
            case .complex(_, let handler):
                return handler(html)
            }
        }
        
        // MARK: CaseIterable
        static let allCases: [Self] = [.blockQuote, .codeBlock, .emphasis, .heading, .image, .inlineCode, .lineBreak, .link, .paragraph, .strikethrough, .strong, .thematicBreak]
        
        // MARK: Equatable
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
        }
        
        // MARK: CustomStringConvertible
        var description: String {
            switch self {
            case .pattern:
                return "\(name) (HTML pattern conversion)"
            case .complex:
                return "\(name) (HTML complex conversion)"
            }
        }
    }
}


/*
init(string: String) {
    let patterns: [(String, String)] = [
        ("(^|\\s)/([\\w\\-\\.!~#?&=+\\*'\"(),\\/]+).(m4a|mp3)", "$1<audio src=\"$2.$3\" preload=\"metadata\" controls>"), // Embed local audio
        ("(^|\\s)/([\\w\\-\\.!~#?&=+\\*'\"(),\\/]+).(m4v|mov|mp4)", "$1<video src=\"$2.$3\" preload=\"metadata\" controls>"), // Embed local video
        ("(^|\\s)/([\\w\\-\\.!~#?&=+\\*'\"(),\\/]+).(png|gif|jpg|jpeg)", "$1<a href=\"$2.$3\"><img src=\"$2.$3\"></a>"), // Embed local images
        ("(https?:\\/\\/)([\\w\\-\\.!~?&+\\*'\"(),\\/]+)", "<a href=\"$1$2\">$2</a>"), // Hyperlink absolute URLs
        ("(^|\\s)/([\\w\\-\\.!~#?&=+\\*'\"(),\\/]+)", "$1<a href=\"$2\">$2</a>"), // Hyperlink relative URIs
        ("(^|\\s)([A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4})", "$1<a href=\"mailto:$2\">$2</a>"), // Hyperlink email addresses
        ("(^|\\s)@([a-z0-9_]+)", "$1<a href=\"https://twitter.com/$2\">@$2</a>"), // Hyperlink Twitter names
        ("(^|\\s)#([a-z0-9_]+)", "$1<a href=\"https://twitter.com/search?q=%23$2&src=hash\">#$2</a>") // Hyperlink Twitter hashtags
    ]
    var HTML = string
    for pattern in patterns {
        HTML = (try! NSRegularExpression(pattern: pattern.0, options: NSRegularExpression.Options.caseInsensitive)).stringByReplacingMatches(in: HTML as String, options: [], range: NSMakeRange(0, HTML.count), withTemplate: pattern.1)
    }
    HTML = HTML.replacingOccurrences(of: "\n", with: "<br>")
    self = HTML
} */
