import Foundation
import ArgumentParser
import Downer

@main
struct Main: ParsableCommand {
    @Argument(help: "Specify path to text file.")
    var path: String
    
    @Option(name: .shortAndLong,  help: "Set output file format.")
    var format: [Format] = Format.allCases
    
    @Flag(name: .shortAndLong, help: "Overwrite existing file(s).")
    var replace: Bool = false
    
    // MARK: ParsableCommand
    static var configuration = CommandConfiguration(commandName: "\(Bundle.main.executableURL!.lastPathComponent)",
        abstract: "Process individual Markdown files.")
    
    func run() throws {
        let document: Document = try Document(path: path)
        for format in self.format {
            print("Saved: \(try document.write(format, to: path, replace: replace))")
        }
    }
}

extension Format: ExpressibleByArgument {
    
}
