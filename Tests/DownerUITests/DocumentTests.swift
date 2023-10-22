import XCTest
@testable import DownerUI
import Downer

final class DocumentTests: XCTestCase {
    
}

extension DocumentTests {
    func testDescriptionInit() throws {
        XCTAssertEqual(Downer.Document(document.html, convertHTML: true)!.description, document.converted)
    }
}

private let document: (html: HTML, converted: String) = ("""
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

""", """
\u{FEFF}# Markdown Document

[![](markdown-image.svg)](markdown-image.svg)

## Think different

> Here’s to the crazy ones.
>
> 1. The misfits
> 2. The rebels
> 3. The _troublemakers_
>
> The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can `quote` them, ~~disagree~~ with them, glorify or vilify them. <span>About the only thing you can’t do is ignore them.</span> Because they change things.
>
> __They push the human race forward__.
>
> And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.
>
> [Think different](https://apple.com)

-----

| Reference | Link |
| --- | --- |
| GitHub Flavored Markdown | [gfm](https://github.github.com/gfm) |
| Daring Fireball | [https://daringfireball.net/projects/markdown](https://daringfireball.net/projects/markdown) |

###### Things I __hate__

* [ ] ~~Vandalism~~
* [x] _Irony_
* [x] Lists
""")
