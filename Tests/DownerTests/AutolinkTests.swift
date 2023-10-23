import XCTest
@testable import Downer

final class AutolinkTests: XCTestCase {
    func testLink() throws {
        XCTAssertEqual(try Autolink.link.convert(link.0), link.1)
    }
    
    func testEmail() throws {
        XCTAssertEqual(try Autolink.email.convert(email.0), email.1)
    }
}

private let link: (HTML, HTML) = ("""
<p>For example, you can view the Markdown source for the article text on this page here:
http://daringfireball.net/projects/markdown/index.text</p>
<p>(You can use this <code>.text</code> suffix trick to view the Markdown source for the content of each of the pages in this section, e.g. the https://daringfireball.net/projects/markdown/syntax and <a href="https://daringfireball.net/projects/markdown/license">License pages</a>.)</p>
""", """
<p>For example, you can view the Markdown source for the article text on this page here:
<a href="http://daringfireball.net/projects/markdown/index.text">daringfireball.net/projects/markdown/index.text</a></p>
<p>(You can use this <code>.text</code> suffix trick to view the Markdown source for the content of each of the pages in this section, e.g. the <a href="https://daringfireball.net/projects/markdown/syntax">daringfireball.net/projects/markdown/syntax</a> and <a href="https://daringfireball.net/projects/markdown/license">License pages</a>.)</p>
""")

private let email: (HTML, HTML) = ("""
<p>mailto:toddheasley@me.com <a href="mailto:toddheasley@aol.com">toddheasley@aol.com</a>
mailto:toddheasley@mac.com toddheasley@gmail.com</p>
""", """
<p><a href="mailto:toddheasley@me.com">toddheasley@me.com</a> <a href="mailto:toddheasley@aol.com">toddheasley@aol.com</a>
<a href="mailto:toddheasley@mac.com">toddheasley@mac.com</a> toddheasley@gmail.com</p>
""")
