import Logging

package nonisolated(unsafe) var logger = Logger(label: "com.kattouf.swift-lsp-server-sample")

package func setupLogger() {
    logger.logLevel = .info
    LoggingSystem.bootstrap(StreamLogHandler.standardError)
}
