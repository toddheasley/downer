import XCTest
@testable import DownerUI

final class HTMLTests: XCTestCase {
    
}

extension HTMLTests {
    func testBlockQuoteConversion() throws {
        XCTAssertEqual(try HTML.Conversion.blockQuote.convert(blockQuote.html), blockQuote.converted)
    }
    
    func testCodeBlockConversion() throws {
        XCTAssertEqual(try HTML.Conversion.codeBlock.convert(codeBlock.html), codeBlock.converted)
    }
    
    func testEmphasisConversion() throws {
        XCTAssertEqual(try HTML.Conversion.emphasis.convert(emphasis.html), emphasis.converted)
    }
    
    func testHeadingConversion() throws {
        XCTAssertEqual(try HTML.Conversion.heading.convert(heading.html), heading.converted)
    }
    
    func testImageConversion() throws {
        XCTAssertEqual(try HTML.Conversion.image.convert(image.html), image.converted)
    }
    
    func testInlineCodeConversion() throws {
        XCTAssertEqual(try HTML.Conversion.inlineCode.convert(inlineCode.html), inlineCode.converted)
    }
    
    func testLineBreakConversion() throws {
        XCTAssertEqual(try HTML.Conversion.lineBreak.convert(lineBreak.html), lineBreak.converted)
    }
    
    func testLinkConversion() throws {
        XCTAssertEqual(try HTML.Conversion.link.convert(link.html), link.converted)
    }
    
    func testOrderedListConversion() throws {
        XCTAssertEqual(try HTML.Conversion.orderedList.convert(orderedList.html), orderedList.converted)
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
    
    func testTableConversion() {
        XCTAssertEqual(try HTML.Conversion.table.convert(table.html), table.converted)
    }
    
    func testTaskListConversion() {
        XCTAssertEqual(try HTML.Conversion.taskList.convert(taskList.html), taskList.converted)
    }
    
    func testThematicBreakConversion() {
        XCTAssertEqual(try HTML.Conversion.thematicBreak.convert(thematicBreak.html), thematicBreak.converted)
    }
    
    func testUnorderedListConversion() throws {
        XCTAssertEqual(try HTML.Conversion.unorderedList.convert(unorderedList.html), unorderedList.converted)
    }
    
    func testLeafBlocks() {
        XCTAssertEqual(HTML.Conversion.leafBlocks.count, 14)
    }
    
    func testContainerBlocks() {
        XCTAssertEqual(HTML.Conversion.containerBlocks.count, 1)
    }
    
    func testInlines() {
        XCTAssertEqual(HTML.Conversion.inlines.count, 10)
    }
    
    // MARK: CaseIterable
    func testConversionAllCases() {
        XCTAssertEqual(HTML.Conversion.allCases.count, 25)
    }
}

private typealias Conversion = (html: HTML, converted: String)

private let blockQuote: Conversion = ("""
<blockquote>
    <p>Markdown uses email-style characters for blockquoting.
    </p>
    <p>Multiple paragraphs need to be prepended individually.
    </p>
</blockquote>
""", """

> <p>Markdown uses email-style characters for blockquoting.
> </p>
> <p>Multiple paragraphs need to be prepended individually.
> </p>

""")

private let codeBlock: Conversion = ("""
<pre>
    <code>
    <span class="gh">Heading</span>
    
    Paragraphs are separated
    by a blank line.

    Two spaces at the end of a line
    produce a line break.</code>
</pre>
""", """
```

    <span class="gh">Heading</span>
    
    Paragraphs are separated
    by a blank line.

    Two spaces at the end of a line
    produce a line break.
```

""")

private let emphasis: Conversion = ("""
<p>Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext <em class="italic">(c. 1992)</em>, Textile <i>(c. 2002)</i>, and reStructuredText <em>(c. 2002)</em>.</p>
""", """
<p>Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext _(c. 1992)_, Textile _(c. 2002)_, and reStructuredText _(c. 2002)_.</p>
""")

private let heading: Conversion = ("""
<h1 disabled>Markdown</h1>
<h2>     Variants
</h2><h3><a href="https://github.github.com/gfm/">GitHub Flavored Markdown</a></h3>
<h4 >Container blocks</h4>
<h5 class='normal'></h5>

<h6>Inlines</h6>
""", """
# Markdown

##      Variants

### <a href="https://github.github.com/gfm/">GitHub Flavored Markdown</a>

#### Container blocks

##### \n

###### Inlines

""")

private let image: Conversion = ("""
<p><a href="/wiki/File:Markdown-mark.svg" class="mw-file-description"><img src="//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/175px-Markdown-mark.svg.png" decoding="async" width="175" height="108" class="mw-file-element" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/263px-Markdown-mark.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/350px-Markdown-mark.svg.png 2x" data-file-width="208" data-file-height="128"/></a></p>
""", """
<p><a href="/wiki/File:Markdown-mark.svg" class="mw-file-description">![](//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/175px-Markdown-mark.svg.png)</a></p>
""")

private let inlineCode: Conversion = ("""
<p>Depending on implementation, basic inline HTML tags may be supported. Italic text may be implemented by <code title="Italic>_underscores_</code> and/or <code>*single-asterisks*</code>.</p>
""", """
<p>Depending on implementation, basic inline HTML tags may be supported. Italic text may be implemented by `_underscores_` and/or `*single-asterisks*`.</p>
""")

private let lineBreak: Conversion = ("""
<p>Paragraphs are separatedby a blank line.<br /><br>Two spaces at the end of a line<br/>produce a line break.</p>
""", """
<p>Paragraphs are separatedby a blank line.  \n  \nTwo spaces at the end of a line  \nproduce a line break.</p>
""")

private let link: Conversion = ("""
<p><b>![](//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/175px-Markdown-mark.svg.png)</b> is a <a title="Lightweight markup language"href='/wiki/Lightweight_markup_language'>lightweight markup language</a> for creating <a href="/wiki/Formatted_text" title="Formatted text"></a> using a <a href="https://en.wikipedia.org/wiki/Text_editor" title="Text editor">plain-text editor</a>.</p>
""", """
<p><b>![](//upload.wikimedia.org/wikipedia/commons/thumb/4/48/Markdown-mark.svg/175px-Markdown-mark.svg.png)</b> is a [lightweight markup language](/wiki/Lightweight_markup_language) for creating [/wiki/Formatted_text]() using a [plain-text editor](https://en.wikipedia.org/wiki/Text_editor).</p>
""")

private let orderedList: Conversion = ("""
<ol>
<li>foo</li>
<li></li>
<li>bar</li>
</ol>
""", """

1. foo
2. 
3. bar

""")

private let paragraph: Conversion = ("""
<p>Paragraphs are separated by a blank line.</p><p>Two spaces at the end of a line<br/>produce a line break.</p>
""", """
\nParagraphs are separated by a blank line.\n\n\nTwo spaces at the end of a line<br/>produce a line break.\n\n
""")

private let strikethrough: Conversion = ("""
<p>The behavior of some <del disabled>of these</del> ports diverged from the reference implementation, as Markdown was <del>only characterised by</del> an informal specification and a Perl implementation for conversion to HTML.</p>
""", """
<p>The behavior of some ~~of these~~ ports diverged from the reference implementation, as Markdown was ~~only characterised by~~ an informal specification and a Perl implementation for conversion to HTML.</p>
""")

private let strong: Conversion = ("""
<p>A <strong title="LML" data="AEAE-9948">lightweight markup language</strong> (<strong>LML</strong>), also termed a <b>simple</b> or <b>humane markup language</b>, is a markup language with simple, unobtrusive syntax.</p>
""", """
<p>A __lightweight markup language__ (__LML__), also termed a __simple__ or __humane markup language__, is a markup language with simple, unobtrusive syntax.</p>
""")

private let table: Conversion = ("""
<table>
    <thead>
    <tr>
    <th>foo</th><th>bar</th></tr>
    </thead>
<tbody>
    <tr>
        <td>baz</td>
        <td>bim</td>
    </tr>
</tbody>
</table>
""", """

| foo | bar
| --- | ---
| baz | bim

""")

private let taskList: Conversion = ("""
<ul>
    <li><input type="checkbox" checked> foo</li>
    <li><input checked="true" disabled="" type='checkbox'></li>
    <li><input type="checkbox">bar</li>
</ul>
""", """
<ul>
    <li>[x]  foo</li>
    <li>[x] </li>
    <li>[ ] bar</li>
</ul>
""")

private let thematicBreak: Conversion = ("""
<p>Horizontal rule:</p><hr/>\n<hr /><hr class="ruler" /> <hr>
""", """
<p>Horizontal rule:</p>\n-----\n\n\n\n-----\n\n\n-----\n\n \n-----\n\n
""")

private let unorderedList: Conversion = ("""
<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>
""", """

* foo
* 
* bar

""")
