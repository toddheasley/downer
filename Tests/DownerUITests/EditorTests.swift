import XCTest
@testable import DownerUI

final class EditorTests: XCTestCase {
    
}

extension EditorTests {
    func testActionDefault() {
        XCTAssertEqual(Editor.Action.default, [
            .createLink(),
            .toggleBold,
            .toggleItalic,
            .toggleStrikethrough
        ])
    }
    
    // MARK: CaseIterable
    func testActionAllCases() {
        XCTAssertEqual(Editor.Action.allCases, [
            .createLink(),
            .insertImage(),
            .insertOrderedList,
            .insertUnorderedList,
            .toggleBold,
            .toggleItalic,
            .toggleStrikethrough,
            .createBlockquote,
            .createHeading(),
            .insertCheckbox,
            .insertCodeBlock,
            .insertLineBreak,
            .insertTable(),
            .insertThemeBreak,
            .toggleCode
        ])
    }
    
    // MARK: CustomStringConvertible
    func testActionDescription() {
        XCTAssertEqual(Editor.Action.createLink().description, "create link…")
        XCTAssertEqual(Editor.Action.insertImage().description, "insert image…")
        XCTAssertEqual(Editor.Action.insertOrderedList.description, "insert numbered list")
        XCTAssertEqual(Editor.Action.insertUnorderedList.description, "insert bulleted list")
        XCTAssertEqual(Editor.Action.toggleBold.description, "toggle bold")
        XCTAssertEqual(Editor.Action.toggleItalic.description, "toggle italic")
        XCTAssertEqual(Editor.Action.toggleStrikethrough.description, "toggle strike")
        XCTAssertEqual(Editor.Action.createBlockquote.description, "create blockquote")
        XCTAssertEqual(Editor.Action.createHeading(0).description, "create #0 heading")
        XCTAssertEqual(Editor.Action.createHeading(6).description, "create #6 heading")
        XCTAssertEqual(Editor.Action.createHeading(7).description, "create #7 heading")
        XCTAssertEqual(Editor.Action.createHeading().description, "create #1 heading")
        XCTAssertEqual(Editor.Action.insertCheckbox.description, "insert checkbox")
        XCTAssertEqual(Editor.Action.insertCodeBlock.description, "insert code block")
        XCTAssertEqual(Editor.Action.insertLineBreak.description, "insert line break")
        XCTAssertEqual(Editor.Action.insertTable(4, 3).description, "insert 3x4 table")
        XCTAssertEqual(Editor.Action.insertTable(2).description, "insert 1x2 table")
        XCTAssertEqual(Editor.Action.insertTable().description, "insert table")
        XCTAssertEqual(Editor.Action.insertThemeBreak.description, "insert theme break")
        XCTAssertEqual(Editor.Action.toggleCode.description, "toggle code")
    }
}

extension EditorTests {
    
    // MARK: Decodable
    func testLinkDecoderInit() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(Editor.Link.self, from: "{\"href\": \"\",\"text\": \"Downer\"}".data(using: .utf8)!))
        let links: [Editor.Link] = try JSONDecoder().decode([Editor.Link].self, from: link)
        XCTAssertEqual(links[0].href.absoluteString, "/Documents/Downer/downer")
        XCTAssertEqual(links[0].text, "")
        XCTAssertEqual(links[1].href.absoluteString, "https://github.com/toddheasley/downer")
        XCTAssertEqual(links[1].text, "Downer")
        XCTAssertEqual(links[2].href.absoluteString, "https://github.com/toddheasley/downer")
        XCTAssertEqual(links[2].text, "")
    }
    
    // MARK: CustomStringConvertible
    func testLinkDescription() {
        XCTAssertEqual(Editor.Link("", href: URL(string: "/Documents/Downer/downer")!).description, "[/Documents/Downer/downer]()")
        XCTAssertEqual(Editor.Link("Downer", href: URL(string: "https://github.com/toddheasley/downer")!).description, "[Downer](https://github.com/toddheasley/downer)")
        XCTAssertEqual(Editor.Link(href: URL(string: "https://github.com/toddheasley/downer")!).description, "[https://github.com/toddheasley/downer]()")
    }
    
    // MARK: Decodable
    func testSelectionDecoderInit() throws {
        let selections: [Editor.Selection] = try JSONDecoder().decode([Editor.Selection].self, from: selection)
        XCTAssertEqual(selections[0].text, "in the Downer GitHub repo")
        XCTAssertEqual(selections[0].nodeName, "P")
        XCTAssertEqual(selections[0].rect, CGRect(x: 8.0, y: 11.0, width: 192.0, height: 44.0))
        XCTAssertEqual(selections[0].link?.href, URL(string: "https://github.com/toddheasley/downer"))
        XCTAssertEqual(selections[0].link?.text, "Downer")
        XCTAssertEqual(selections[1].text, "")
        XCTAssertNil(selections[1].nodeName)
        XCTAssertEqual(selections[1].rect, .zero)
        XCTAssertNil(selections[1].link)
    }
}

private let link: Data = """
[
    {
        "href": "/Documents/Downer/downer"
    },
    {
        "href": "https://github.com/toddheasley/downer",
        "text": "Downer"
    },
    {
        "href": "https://github.com/toddheasley/downer",
        "text": null
    }
]
""".data(using: .utf8)!

private let selection: Data = """
[
    {
        "text": "in the Downer GitHub repo",
        "nodeName": "P",
        "rect": [8.0, 11.0, 192.0, 44.0],
        "link": {
            "href": "https://github.com/toddheasley/downer",
            "text": "Downer"
        }
    },
    {
        
    }
]
""".data(using: .utf8)!
