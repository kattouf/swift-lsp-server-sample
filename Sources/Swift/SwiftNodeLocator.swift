import SwiftSyntax

final class SwiftNodeLocator {
    let tree: SourceFileSyntax
    let locationConverter: SourceLocationConverter
    let parser: SwiftNodeParser

    init(tree: SourceFileSyntax, locationConverter: SourceLocationConverter) {
        self.tree = tree
        self.locationConverter = locationConverter
        parser = SwiftNodeParser.defaultParser()
    }

    func node(at position: OneBasedPosition) -> SwiftNode? {
        let offset = locationConverter.position(ofLine: position.line, column: position.column).utf8Offset
        let position = AbsolutePosition(utf8Offset: offset)

        guard let token = tree.token(at: position),
              let node = token.parent
        else {
            return nil
        }

        var current: SyntaxProtocol? = node
        while let node = current {
            if let parsedNode = parser.parse(node) {
                return parsedNode
            }

            current = node.parent
        }

        return nil
    }
}
