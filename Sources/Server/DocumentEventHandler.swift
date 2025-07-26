import JSONRPC
import LanguageServerProtocol

final class DocumentEventHandler {
    private let hoverService = HoverService()
    private var openDocuments: [DocumentUri: SwiftDocument] = [:]

    func hover(_ params: TextDocumentPositionParams, _ handler: ClientRequest.Handler<HoverResponse>) async throws {
        guard let document = openDocuments[params.textDocument.uri] else {
            logger.debug("Received hover request for non-open document: \(params.textDocument.uri)")
            await handler(.success(nil))
            return
        }
        let hoverResponse: HoverResponse
        do {
            hoverResponse = try await hoverService.hover(at: params.position, in: document)
        } catch {
            logger.error("Error during hover: \(error)")
            hoverResponse = nil
        }
        await handler(.success(hoverResponse))
    }

    func handleTextDocumentDidOpen(_ params: DidOpenTextDocumentParams) async throws {
        guard params.textDocument.isSwift else {
            logger.debug("Ignoring open non-swift document: \(params.textDocument.uri)")
            return
        }
        guard openDocuments.keys.contains(params.textDocument.uri) == false else {
            logger.debug("Ignoring open already open document: \(params.textDocument.uri)")
            return
        }

        let document = try SwiftDocument(params: params)
        openDocuments[params.textDocument.uri] = document
    }

    func handleTextDocumentDidChange(_ params: DidChangeTextDocumentParams) async throws {
        guard let document = openDocuments[params.textDocument.uri] else {
            logger.debug("Received change request for non-open document: \(params.textDocument.uri)")
            return
        }

        for change in params.contentChanges {
            if change.range != nil {
                logger.error("Error: partial document change not supported")
                continue
            } else {
                document.sync(with: change.text)
            }
        }
    }

    func handleTextDocumentDidClose(_ params: DidCloseTextDocumentParams) async throws {
        guard let document = openDocuments[params.textDocument.uri] else {
            logger.debug("Received close request for non-open document: \(params.textDocument.uri)")
            return
        }

        document.close()
        openDocuments[params.textDocument.uri] = nil
    }
}
