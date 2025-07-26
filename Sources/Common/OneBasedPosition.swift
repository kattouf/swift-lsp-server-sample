import LanguageServerProtocol

struct OneBasedPosition: Equatable {
    let line: Int
    let column: Int

    init?(line: Int, column: Int) {
        guard line > 0, column > 0 else {
            return nil
        }

        self.line = line
        self.column = column
    }
}

extension OneBasedPosition: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.line < rhs.line {
            return true
        }
        if lhs.line > rhs.line {
            return false
        }

        if lhs.column < rhs.column {
            return true
        }
        return false
    }
}
