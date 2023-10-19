import Foundation

typealias HTML = String

extension HTML {
    enum Conversion: CaseIterable, Equatable, CustomStringConvertible {
        static let blockQuote: Self = .complex("BlockQuote") { html in
            return html
        }
        
        static let codeBlock: Self = .pattern("CodeBlock", [
            ("<pre.*?>.*?<code.*?>(.*?)</code>.*?</pre>", "```\n$1\n```\n"),
            ("<pre.*?>(.*?)</pre>", "```\n$1\n```\n")
        ])
        
        static let emphasis: Self = .pattern("Emphasis", [
            ("<em.*?>(.*?)</em>", "_$1_"),
            ("<i>(.*?)</i>", "_$1_")
        ])
        
        static let heading: Self = .pattern("Heading", [
            ("<h6.*?>(.*?)</h6>", "###### $1\n"),
            ("<h5.*?>(.*?)</h5>", "##### $1\n"),
            ("<h4.*?>(.*?)</h4>", "#### $1\n"),
            ("<h3.*?>(.*?)</h3>", "### $1\n"),
            ("<h2.*?>(.*?)</h2>", "## $1\n"),
            ("<h1.*?>(.*?)</h1>", "# $1\n")
        ])
        
        static let image: Self = .pattern("Image", [
            ("<img.*?src=[\"']([^\"']*)[\"'].*?>", "![]($1)")
        ])
        
        static let inlineCode: Self = .pattern("InlineCode", [
            ("<code.*?>(.*?)</code>", "`$1`")
        ])
        
        static let lineBreak: Self = .pattern("LineBreak", [
            ("<br.*?>", "  \n")
        ])
        
        static let link: Self = .pattern("Link", [
            ("<a.*?href=[\"']([^\"']*)[\"'][^>]*>(.*?)</a>", "[$2]($1)"),
            ("(\\[\\]\\()([^\\)]*)(\\))", "[$2]()")
        ])
        
        static let orderedList: Self = .complex("OrderedList") { html in
            return html
        }
        
        static let paragraph: Self = .pattern("Paragraph", [
            ("<p>(.*?)</p>", "\n$1\n\n")
        ])
        
        static let strikethrough: Self = .pattern("Strikethrough", [
            ("<del.*?>(.*?)</del>", "~~$1~~")
        ])
        
        static let strong: Self = .pattern("Strong", [
            ("<strong.*?>(.*?)</strong>", "__$1__"),
            ("<b>(.*?)</b>", "__$1__")
        ])
        
        static let table: Self = .complex("Table") { html in
            return html
        }
        
        static let thematicBreak: Self = .pattern("ThematicBreak", [
            ("<hr.*?>", "\n-----\n\n")
        ])
        
        static let unorderedList: Self = .complex("UnorderedList") { html in
            return html
        }
        
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
                    html = (try NSRegularExpression(pattern: pattern.0, options: [.caseInsensitive, .dotMatchesLineSeparators])).stringByReplacingMatches(in: html, options: [], range: NSMakeRange(0, html.count), withTemplate: pattern.template)
                }
                return html
            case .complex(_, let handler):
                return handler(html)
            }
        }
        
        // MARK: CaseIterable
        static let allCases: [Self] = [.emphasis, .inlineCode, .lineBreak, .link, .strikethrough, .strong, .image] + [.blockQuote, .codeBlock, .heading, .orderedList, .paragraph, .table, .thematicBreak, .unorderedList]
        
        // MARK: Equatable
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
        }
        
        // MARK: CustomStringConvertible
        var description: String { name }
    }
}
