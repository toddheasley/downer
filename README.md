# Downer

Downer is my personal toolkit for all things [Markdown.](https://daringfireball.net/projects/markdown)

### Supported Platforms

Written in [Swift](https://developer.apple.com/documentation/swift) 5.9 for Apple stuff:

* [macOS](https://developer.apple.com/macos) 14 Sonoma
* [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad)/[tvOS](https://developer.apple.com/tvos) 17
* [watchOS](https://developer.apple.com/watchos) 10
* [visionOS](https://developer.apple.com/visionos)

Build with [Xcode](https://developer.apple.com/xcode) 15 or newer. Command-line interface depends on [Swift Argument Parser.](https://github.com/apple/swift-argument-parser)

## Live Preview Dingus

![](docs/downer.png)

## Command-Line Interface

`Downer` package includes `downer-cli`, an executable target for processing individual Markdown files. Given a path to almost any text file, `downer-cli` creates both HTML and formatted Markdown versions, preserving the source file:

```zsh
toddheasley Desktop % ls
README.md
toddheasley Desktop % downer-cli README.md 
Saved: README~.md
Saved: README.html
toddheasley Desktop % ls
README.html	README.md	README~.md
```

Use `--replace` to overwrite the source file:

```zsh
toddheasley Desktop % ls
README.md
toddheasley Desktop % downer-cli README.md -r
Saved: README.md
Saved: README.html
toddheasley Desktop % ls
README.html	README.md
```

Use `--format` to generate only one format or the other:

```zsh
toddheasley Desktop % ls
README.md
toddheasley Desktop % downer-cli README.md -f hypertext
Saved: README.html
toddheasley Desktop % ls
README.html	README.md
```

## `Downer` Reference

### Markdown Syntax

`Downer` parses [GitHub Flavored Markdown](https://github.github.com/gfm) using [cmark-gfm.](https://github.com/github/cmark-gfm) It will handle any mixture of random syntax thrown at it, but it’s weird and opinionated about a handful of things that I’m weird and opinionated about. Beware the following deviations from normal Markdown behavior:

* [List items](https://github.github.com/gfm/#list-items) are considered leaf blocks. When list items contain multiple child blocks, only the inline content from the first child block is selected. Additional blocks are discarded.
* Hypertext format renders [strong emphasis](https://github.github.com/gfm/#emphasis-and-strong-emphasis) with HTML `<b>` tags, instead of `<strong>`.
* [Link reference definitions](https://github.github.com/gfm/#link-reference-definitions) are ignored _and_ discarded during parsing.
* Support for [Flavored autolinks](https://github.github.com/gfm/#autolinks-extension-) is omitted. Future releases may introduce non-standard autolinking as hypertext formatting options.

Other Flavored extensions for [strikethrough](https://github.github.com/gfm/#strikethrough-extension-), [tables](https://github.github.com/gfm/#tables-extension-) and [task lists](https://github.github.com/gfm/#task-list-items-extension-) are fully supported.

### Examples

`Downer` adopts the same document structure and element naming conventions as its underlying parser, [Swift Markdown.](https://github.com/apple/swift-markdown) Elements are re-parsed into self-rendering, concrete types:

```swift
import Downer

let document: Document = """
[Think different](https://apple.com)
===

Here's to the crazy ones.
-------------------------

1. The misfits
1. The rebels
1. The troublemakers

The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can `quote` them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things.

**They push the human race forward**.

And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.
"""

print(document.elements.first) // # [Think different](https://www.apple.com)
print(document.elements.count) // 6
```

`Document` has two rendering modes, `Format.hypertext` and `.markdown`:

```swift
print(document.description(.hypertext))
```

```html
<h1><a href="https://apple.com">Think different</a></h1>
<h2>Here’s to the crazy ones.</h2>
<ol>
    <li>The misfits</li>
    <li>The rebels</li>
    <li>The troublemakers</li>
</ol>
<p>The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can <code>quote</code> them, disagree with them, glorify or vilify them. About the only thing you can’t do is ignore them. Because they change things.</p>
<p><b>They push the human race forward</b>.</p>
<p>And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.</p>
```

Markdown renders by default:

```swift
print(document)
```

```markdown
# [Think different](https://apple.com)

## Here’s to the crazy ones.

1. The misfits
2. The rebels
3. The troublemakers

The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can `quote` them, disagree with them, glorify or vilify them. About the only thing you can’t do is ignore them. Because they change things.

__They push the human race forward__.

And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.
```
