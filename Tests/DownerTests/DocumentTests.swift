import XCTest
@testable import Downer

final class DocumentTests: XCTestCase {
    func testDescription() {
        XCTAssertEqual(document.description(.markdown), markdown)
        XCTAssertEqual(document.description(.hypertext), hypertext)
    }
    
    func testDescriptionInit() {
        XCTAssertEqual(document.elements.count, 13)
    }
}

private let document: Downer.Document = """
Markdown Document
===

[![Markdown image](markdown-image.svg)](markdown-image.svg)

## Think different

> Here's to the crazy ones.
>
> 1. The misfits
> 2. The rebels
> 3. The _troublemakers_
>
> The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo.
You can `quote` them, ~~disagree~~ with them, glorify or vilify them. <span>About the only thing you can't do is ignore them.</span> Because they change things.
>
> **They push the human race forward**.
>
> And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.
>
> [Think different](https://apple.com)
>

___




Hypertext
---------

For example, to add an HTML `<table>` to
a <a href="https://daringfireball.net/projects/markdown">Markdown</a> article:

```markdown
This is a regular paragraph.
 
<table>
    <tr>
        <td>Foo</td>
    </tr>
</table>
 
This is another regular paragraph.
```

<table>
    <tr>
        <td>Foo</td>
    </tr>
</table>

***

Reference | Link
------------------------ | ----
GitHub Flavored Markdown | [gfm](https://github.github.com/gfm)
Daring Fireball          | [](https://daringfireball.net/projects/markdown)

###### Things I __hate__
- [ ] ~~Vandalism~~
- [x] *Irony*
- [x] Lists

"""

private let markdown: String = """
\u{FEFF}# Markdown Document

[![Markdown image](markdown-image.svg)](markdown-image.svg)

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

## Hypertext

For example, to add an HTML `<table>` to a <a href="https://daringfireball.net/projects/markdown">Markdown</a> article:

```markdown
This is a regular paragraph.

<table>
    <tr>
        <td>Foo</td>
    </tr>
</table>

This is another regular paragraph.
```

<table>
    <tr>
        <td>Foo</td>
    </tr>
</table>

-----

| Reference | Link |
| --- | --- |
| GitHub Flavored Markdown | [gfm](https://github.github.com/gfm) |
| Daring Fireball | [](https://daringfireball.net/projects/markdown) |

###### Things I __hate__

* [ ] ~~Vandalism~~
* [x] _Irony_
* [x] Lists

"""

private let hypertext: String = """
\u{FEFF}<h1>Markdown Document</h1>
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
