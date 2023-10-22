import Foundation

typealias HTML = String

extension HTML.Conversion: CaseIterable {
    static let blockQuote: Self = .modifier("<blockquote.*?>(.*?)</blockquote>") { html in
        var html: HTML = try! HTML.Conversion.template("<blockquote.*?>(.*?)</blockquote>", "$1").convert(html).trimmed()
        html = html.components(separatedBy: "\n").map { $0.isEmpty ? ">" : "> \($0.trimmed())" }.joined(separator: "\n")
        return "\n\(html)\n"
    }
    
    static let codeBlock: [Self] = [
        .template("<pre.*?>.*?<code.*?>(.*?)</code>.*?</pre>", "```\n$1\n```\n"),
        .template("<pre.*?>(.*?)</pre>", "```\n$1\n```\n")
    ]
    
    static let emphasis: [Self] = [
        .template("<em.*?>(.*?)</em>", "_$1_"),
        .template("<i>(.*?)</i>", "_$1_")
    ]
    
    static let heading: [Self] = [
        .template("<h6.*?>(.*?)</h6>", "###### $1\n"),
        .template("<h5.*?>(.*?)</h5>", "##### $1\n"),
        .template("<h4.*?>(.*?)</h4>", "#### $1\n"),
        .template("<h3.*?>(.*?)</h3>", "### $1\n"),
        .template("<h2.*?>(.*?)</h2>", "## $1\n"),
        .template("<h1.*?>(.*?)</h1>", "# $1\n")
    ]
    
    static let image: Self = .template("<img.*?src=[\"']([^\"']*)[\"'].*?>", "![]($1)")
    static let inlineCode: Self = .template("<code.*?>(.*?)</code>", "`$1`")
    static let lineBreak: Self = .template("<br.*?>", "  \n")
    
    static let link: [Self] = [
        .template("<a.*?href=[\"']([^\"']*)[\"'][^>]*>(.*?)</a>", "[$2]($1)"),
        .template("(?<!\\!)(\\[\\]\\()([^\\)]*)(\\))", "[$2]()")
    ]
    
    static let orderedList: Self = .modifier("<ol.*?>(.*?)</ol>") { html in
        var items: [HTML] = []
        for item in try! html.substrings(matching: "<li.*?>(.*?)</li>") {
            let item: HTML = try! HTML.Conversion.template("<li.*?>(.*?)</li>", "\(1 + items.count). $1").convert(item)
            items.append(item)
        }
        return "\n\(items.joined(separator: "\n"))\n"
    }
    
    static let paragraph: Self = .template("<p>(.*?)</p>", "\n$1\n\n")
    static let strikethrough: Self = .template("<del.*?>(.*?)</del>", "~~$1~~")
    
    static let strong: [Self] = [
        .template("<strong.*?>(.*?)</strong>", "__$1__"),
        .template("<b>(.*?)</b>", "__$1__")
    ]
    
    static let table: Self = .modifier("<table.*?>(.*?)</table>") { html in
        var rows: [HTML] = []
        for (index, row) in try! html.substrings(matching: "<tr.*?>(.*?)</tr>").enumerated() {
            let heads: [HTML] = try! row.substrings(matching: "<th.*?>(.*?)</th>")
            let cells: [HTML] = try! row.substrings(matching: "<td.*?>(.*?)</td>")
            guard (index == 0 && !heads.isEmpty) || !cells.isEmpty else {
                return html
            }
            if index == 0 {
                rows.append(heads.map { head in
                    try! HTML.Conversion.template("<th.*?>(.*?)</th>", "| $1").convert(head)
                }.joined(separator: " "))
                rows.append(heads.map { _ in
                    "| ---"
                }.joined(separator: " "))
            } else {
                rows.append(cells.map { cell in
                    try! HTML.Conversion.template("<td.*?>(.*?)</td>", "| $1").convert(cell)
                }.joined(separator: " "))
            }
        }
        return "\n\(rows.joined(separator: "\n"))\n"
    }
    
    static let taskList: Self = .modifier("<input.*?type=[\"']checkbox[\"'][^>]*>") { html in
        return "[\(html.contains("checked") ? "x" : " ")] "
    }
    
    static let thematicBreak: Self = .template("<hr.*?>", "\n-----\n\n")
    
    static let unorderedList: Self = .modifier("<ul.*?>(.*?)</ul>") { html in
        var items: [HTML] = []
        for item in try! html.substrings(matching: "<li.*?>(.*?)</li>") {
            let item: HTML = try! HTML.Conversion.template("<li.*?>(.*?)</li>", "* $1").convert(item)
            items.append(item)
        }
        return "\n\(items.joined(separator: "\n"))\n"
    }
    
    static let leafBlocks: [Self] = codeBlock + heading + [orderedList, paragraph, table, taskList, thematicBreak, unorderedList]
    static let containerBlocks: [Self] = [blockQuote]
    static let inlines: [Self] = [image, inlineCode, lineBreak, strikethrough] + emphasis + link + strong
    
    // MARK: CaseIterable
    static let allCases: [Self] =  inlines + leafBlocks + containerBlocks
}

extension HTML {
    enum Conversion {
        typealias Modifier = (HTML) -> String
        
        case modifier(_ pattern: String, _ modifier: Modifier)
        case template(_ pattern: String, _ template: String)
        
        var pattern: String {
            switch self {
            case .modifier(let pattern, _), .template(let pattern, _):
                return pattern
            }
        }
        
        func convert(_ html: HTML) throws -> String {
            switch self {
            case .modifier(_, let modifier):
                return try html.replacingSubstrings(matching: pattern, with: modifier)
            case .template(_, let template):
                return try html.replacingSubstrings(matching: pattern, with: template)
            }
        }
    }
}

extension Array where Element == HTML.Conversion {
    func convert(_ html: HTML) throws -> String {
        var html: HTML = html
        for conversion in self {
            html = try conversion.convert(html)
        }
        return html
    }
}
