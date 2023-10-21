import XCTest
@testable import DownerUI

final class StringTests: XCTestCase {
    
}

extension StringTests {
    func testReplacingSubstringsWithTemplate() throws {
        XCTAssertEqual(try template.0.replacingSubstrings(matching: "<em.*?>(.*?)</em>", with: "_$1_"), template.1)
    }
    
    func testReplacingSubstringsWithModifier() {
        XCTAssertEqual(try modifier.0.replacingSubstrings(matching: "<ol.*?>(.*?)</ol>") { string in
            let string: String = try! string.replacingSubstrings(matching: "<ol.*?>(.*?)</ol>", with: "$1")
            return try! string.replacingSubstrings(matching: "<li.*?>(.*?)</li>", with: "<p>$1</p>")
        }, modifier.1)
    }
    
    func testSubstrings() {
        XCTAssertEqual(try substrings.substrings(matching: "<em.*?>(.*?)</em>"), [
            "<em class=\"italic\">(c. 1992)</em>",
            "<em>(c. 2002)</em>"
        ])
    }
}

private let template: (String, String) = ("""
<p>Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext <em class="italic">(c. 1992)</em>, Textile <i>(c. 2002)</i>, and reStructuredText <em>(c. 2002)</em>.</p>
""", """
<p>Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext _(c. 1992)_, Textile <i>(c. 2002)</i>, and reStructuredText _(c. 2002)_.</p>
""")

private let modifier: (String, String) = ("""
<ol>
  <li>foo</li>
<li>bar</li>
</ol>
<ol start="3">
    <li>baz</li>
</ol>
""", """

  <p>foo</p>
<p>bar</p>


    <p>baz</p>

""")

private let substrings: String = """
Markdown was inspired by pre-existing conventions for marking up plain text in email and usenet posts, such as the earlier markup languages setext <em class="italic">(c. 1992)</em>, Textile <i>(c. 2002)</i>, and reStructuredText <em>(c. 2002)</em>
"""
