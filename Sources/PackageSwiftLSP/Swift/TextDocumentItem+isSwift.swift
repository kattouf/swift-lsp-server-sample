import Foundation
import LanguageServerProtocol

extension TextDocumentItem {
    var isSwift: Bool {
        languageId == "swift"
    }
}
