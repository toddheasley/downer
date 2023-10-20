import XCTest
@testable import DownerUI
import Downer

final class DocumentTests: XCTestCase {
    
}

extension DocumentTests {
    func testDescriptionInit() throws {
        XCTAssertEqual(Downer.Document(document.html, convertHTML: true)?.description, document.converted)
    }
}

private let document: (html: HTML, converted: String) = ("""

""", """

""")


private let html: String = """
<h1>Markdown Document</h1>
<p><a href="markdown-image.svg"><img src="markdown-image.svg" alt="Markdown image"></a></p>
<h2>Think different</h2>
<blockquote>
    <p>Here’s to the crazy ones.</p>
    <ol>
        <li>The misfits</li>
        <li>The rebels</li>
        <li>The <em>troublemakers</em></li>
    </ol>
    <p>The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can <code>quote</code> them, <del>disagree</del> with them, glorify or vilify them. <span>About the only thing you can’t do is ignore them.</span> Because they change things.</p>
    <p><b>They push the human race forward</b>.</p>
    <p>And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.</p>
    <p><a href="https://apple.com">Think different</a></p>
</blockquote>
<hr>
<h2>Hypertext</h2>
<p>For example, to add an HTML <code>&lt;table&gt;</code> to a <a href="https://daringfireball.net/projects/markdown">Markdown</a> article:</p>
<pre>
This is a regular paragraph.

&lt;table&gt;
    &lt;tr&gt;
        &lt;td&gt;Foo&lt;/td&gt;
    &lt;/tr&gt;
&lt;/table&gt;

This is another regular paragraph.
</pre>
<table>
    <tr>
        <td>Foo</td>
    </tr>
</table>
<hr>
<table>
    <tr>
        <th>Reference</th>
        <th>Link</th>
    </tr>
    <tr>
        <td>GitHub Flavored Markdown</td>
        <td><a href="https://github.github.com/gfm">gfm</a></td>
    </tr>
    <tr>
        <td>Daring Fireball</td>
        <td><a href="https://daringfireball.net/projects/markdown">https://daringfireball.net/projects/markdown</a></td>
    </tr>
</table>
<h6>Things I <b>hate</b></h6>
<ul>
    <li><input type="checkbox" disabled> <del>Vandalism</del></li>
    <li><input type="checkbox" disabled checked> <em>Irony</em></li>
    <li><input type="checkbox" disabled checked> Lists</li>
</ul>

"""

// ("(https?:\\/\\/)([\\w\\-\\.!~?&+\\*'\"(),\\/]+)", "<a href=\"$1$2\">$2</a>"), // Hyperlink absolute URLs
// ("(^|\\s)/([\\w\\-\\.!~#?&=+\\*'\"(),\\/]+)", "$1<a href=\"$2\">$2</a>"), // Hyperlink relative URIs
// ("(^|\\s)([A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4})", "$1<a href=\"mailto:$2\">$2</a>"), // Hyperlink email addresses
