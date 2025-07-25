import ArgumentParser

@main
struct CLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift-lsp-server-sample",
        abstract: "Sample Swift LSP server",
    )

    func run() async throws {
        setupLogger()
        let server = Server()
        try await server.start()
    }
}
