import Foundation
import UniformTypeIdentifiers
import DownerUI
import Downer

extension Document {
    @discardableResult func write(_ format: Format = .markdown, to path: String, replace: Bool = false) throws -> String {
        let url: URL = try URL(file: path, format: format, replace: replace)
        try description(format).write(to: url, atomically: true, encoding: .utf8)
        return url.lastPathComponent
    }
    
    init(path: String, convertHTML: Bool = false) throws {
        let url: URL = try URL(file: path)
        guard let document: Self = Self(try String(contentsOf: url), convertHTML: convertHTML) else {
            throw Error.decodingFailed
        }
        self = document
    }
}

extension Document.Error: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .decodingFailed:
            return "File decoding failed"
        case .generic(let description):
            return description
        default:
            fatalError()
        }
    }
}

private extension Format {
    var pathExtension: String {
        return contentType.preferredFilenameExtension!
    }
}

private extension URL {
    init(file path: String, format: Format, replace: Bool = false) throws {
        var path: String = try Self(file: path).deletingPathExtension().path
        if FileManager.default.fileExists(atPath: "\(path).\(format.pathExtension)"), !replace, !path.hasSuffix("~") {
            path += "~"
        }
        self = Self(fileURLWithPath: "\(path).\(format.pathExtension)")
    }
    
    init(file path: String) throws {
        guard FileManager.default.fileExists(atPath: path),
              FileManager.default.isReadableFile(atPath: path) else {
            throw Document.Error.generic("File\(!path.isEmpty ? " '\(path)'" : "") not found")
        }
        self = Self(fileURLWithPath: path)
    }
}
