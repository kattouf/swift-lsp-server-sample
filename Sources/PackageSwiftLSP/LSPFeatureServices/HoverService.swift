import LanguageServerProtocol
import Workspace

final class HoverService {
    func hover(
        at position: Position,
        in swiftDocument: SwiftDocument
    ) async throws -> HoverResponse {
        logger.info("Looking for hover at \(position) in \(swiftDocument.uri)")
        guard let swiftNode = swiftDocument.node(at: position) else {
            return nil
        }

        switch swiftNode {
        case let .functionDeclaration(name):
            let hoverContent = "### This is a function:\n## Named: \(name)##Length: \(name.count)"
            return Hover(
                contents: .optionC(.init(kind: .markdown, value: hoverContent)),
                range: nil
            )
        case let .variableDeclaration(name):
            let hoverContent = "### This is a variable:\n## Named: \(name)##Length: \(name.count)"
            return Hover(
                contents: .optionC(.init(kind: .markdown, value: hoverContent)),
                range: nil
            )
        }
    }
}
