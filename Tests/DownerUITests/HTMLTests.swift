import XCTest
@testable import DownerUI

final class HTMLTests: XCTestCase {
    
}

extension HTMLTests {
    func testEmphasisConversion() throws {
        XCTAssertEqual(try HTML.Conversion.emphasis.convert(emphasis.html), emphasis.converted)
    }
    
    func testLineBreakConversion() {
        XCTAssertEqual(try HTML.Conversion.lineBreak.convert(lineBreak.html), lineBreak.converted)
    }
    
    func testLinkConversion() throws {
        XCTAssertEqual(try HTML.Conversion.link.convert(link.html), link.converted)
    }
    
    func testParagraphConversion() throws {
        XCTAssertEqual(try HTML.Conversion.paragraph.convert(paragraph.html), paragraph.converted)
    }
    
    func testStrinkethroughConversion() throws {
        XCTAssertEqual(try HTML.Conversion.strikethrough.convert(strikethrough.html), strikethrough.converted)
    }
    
    func testStrongConversion() throws {
        XCTAssertEqual(try HTML.Conversion.strong.convert(strong.html), strong.converted)
    }
    
    func testThematicBreakConversion() {
        XCTAssertEqual(try HTML.Conversion.thematicBreak.convert(thematicBreak.html), thematicBreak.converted)
    }
    
    // MARK: CaseIterable
    func testConversionAllCases() {
        XCTAssertEqual(HTML.Conversion.allCases, [.blockQuote, .codeBlock, .emphasis, .heading, .image, .inlineCode, .lineBreak, .link, .paragraph, .strikethrough, .strong, .thematicBreak])
    }
}

private let emphasis: (html: HTML, converted: String) = ("""
<p>Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext <i >(c. 1992)</i>, Textile <i class="em">(c. 2002)</i>, and reStructuredText <em>(c. 2002)</em>.</p>
""", """
<p>Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext _(c. 1992)_, Textile _(c. 2002)_, and reStructuredText _(c. 2002)_.</p>
""")

private let lineBreak: (html: HTML, converted: String) = ("""
<p>Paragraphs are separatedby a blank line.<br /><br>Two spaces at the end of a line<br/>produce a line break.</p>
""", """
<p>Paragraphs are separatedby a blank line.  \n  \nTwo spaces at the end of a line  \nproduce a line break.</p>
""")

private let link: (html: HTML, converted: String) = ("""
<p><b>Markdown</b> is a <a title="Lightweight markup language"href='/wiki/Lightweight_markup_language'>lightweight markup language</a> for creating <a href="/wiki/Formatted_text" title="Formatted text"></a> using a <a href="https://en.wikipedia.org/wiki/Text_editor" title="Text editor">plain-text editor</a>.</p>
""", """
<p><b>Markdown</b> is a [lightweight markup language](/wiki/Lightweight_markup_language) for creating [](/wiki/Formatted_text) using a [plain-text editor](https://en.wikipedia.org/wiki/Text_editor).</p>
""")

private let paragraph: (html: HTML, converted: String) = ("""
<p class='p'>Paragraphs are separated by a blank line.</p><p>Two spaces at the end of a line<br/>produce a line break.</p>
""", """
\nParagraphs are separated by a blank line.\n\n\nTwo spaces at the end of a line<br/>produce a line break.\n\n
""")

private let strikethrough: (html: HTML, converted: String) = ("""
<p>The behavior of some <del disabled>of these</del> ports diverged from the reference implementation, as Markdown was <del>only characterised by</del> an informal specification and a Perl implementation for conversion to HTML.</p>
""", """
<p>The behavior of some ~~of these~~ ports diverged from the reference implementation, as Markdown was ~~only characterised by~~ an informal specification and a Perl implementation for conversion to HTML.</p>
""")

private let strong: (html: HTML, converted: String) = ("""

""", """

""")

private let thematicBreak: (html: HTML, converted: String) = ("""

""", """

""")
