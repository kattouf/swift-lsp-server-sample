import ConcurrencyExtras
import Foundation
import LanguageServerProtocol
import SwiftSyntax

final class SwiftDocument: Sendable {
    enum Error: Swift.Error {
        case wrongFileType
        case invalidDocumentUri(uri: String)
    }

    private let parser: SwiftParser
    private let parsedSwiftFile: LockIsolated<ParsedSwiftFile>

    let uri: DocumentUri

    // MARK: - Public

    convenience init(
        params: DidOpenTextDocumentParams
    ) throws {
        guard params.textDocument.isSwift else {
            throw Error.wrongFileType
        }

        self.init(filePath: params.textDocument.uri, source: params.textDocument.text)
    }

    init(filePath: String, source: String) {
        let parser = SwiftParser()
        let parsedSwiftFile = parser.parse(filePath: filePath, source: source)

        self.parser = parser
        self.parsedSwiftFile = .init(parsedSwiftFile)
        uri = filePath
        logger.info("Open document: \(filePath)")
    }

    func sync(with newText: String) {
        parsedSwiftFile.setValue(parser.parse(filePath: uri, source: newText))
        logger.info("Sync document: \(uri)")
    }

    func close() {
        logger.info("Close document: \(uri)")
    }

    func node(at position: Position) -> SwiftNode? {
        let swiftNodeLocator = SwiftNodeLocator(
            tree: parsedSwiftFile.tree,
            locationConverter: parsedSwiftFile.locationConverter
        )
        let node = swiftNodeLocator.node(at: OneBasedPosition(position))
        if let node {
            logger.debug("Found node at \(position) in \(uri)")
            logger.debug("Node: \(node)")
        } else {
            logger.debug("No node found at \(position) in \(uri)")
        }
        return node
    }
}
