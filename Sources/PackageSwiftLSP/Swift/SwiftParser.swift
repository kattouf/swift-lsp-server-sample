import Foundation
import SwiftParser
import SwiftSyntax

final class SwiftParser: Sendable {
    func parse(filePath: String, source: String) -> ParsedSwiftFile {
        let tree = Parser.parse(source: source)
        let converter = SourceLocationConverter(fileName: filePath, tree: tree)
        return ParsedSwiftFile(tree: tree, locationConverter: converter)
    }
}

struct ParsedSwiftFile: Sendable {
    let tree: SourceFileSyntax
    let locationConverter: SourceLocationConverter

    fileprivate init(tree: SourceFileSyntax, locationConverter: SourceLocationConverter) {
        self.tree = tree
        self.locationConverter = locationConverter
    }
}
