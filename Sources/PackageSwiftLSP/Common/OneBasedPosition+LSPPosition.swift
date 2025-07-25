import LanguageServerProtocol

extension OneBasedPosition {
    init(_ zeroBasedPosition: Position) {
        self.line = zeroBasedPosition.line + 1
        self.column = zeroBasedPosition.character + 1
    }
}
