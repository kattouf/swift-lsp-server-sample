import SwiftSyntax

struct SwiftNodeParser {
    let parse: (_ node: SyntaxProtocol) -> SwiftNode?
}

// MARK: - Default

extension SwiftNodeParser {
    static func defaultParser() -> SwiftNodeParser {
        .compositeParser(parsers: [
            .functionDeclarationParser(),
            .variableDeclarationParser(),
        ])
    }

    static func compositeParser(
        parsers: [SwiftNodeParser]
    ) -> SwiftNodeParser {
        SwiftNodeParser { node in
            for parser in parsers {
                if let node = parser.parse(node) {
                    return node
                }
            }
            return nil
        }
    }
}

// MARK: - Function Declaration Parser

extension SwiftNodeParser {
    static func functionDeclarationParser() -> SwiftNodeParser {
        return SwiftNodeParser { node in
            if let decl = node.as(FunctionDeclSyntax.self) {
                return .functionDeclaration(decl.name.text)
            }

            return nil
        }
    }
}

// MARK: - Variable Declaration Parser

extension SwiftNodeParser {
    static func variableDeclarationParser() -> SwiftNodeParser {
        return SwiftNodeParser { node in
            if let decl = node.as(VariableDeclSyntax.self),
               let name = decl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            {
                return .variableDeclaration(name)
            }

            return nil
        }
    }
}
