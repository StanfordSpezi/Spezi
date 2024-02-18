//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SpeziFoundation


extension Module {
    fileprivate var loggerCategory: String {
        "\(Self.self)"
    }
}


extension Spezi {
    /// Access the application logger.
    ///
    /// Access the global Spezi Logger. If used with ``Module/Application`` property wrapper you can create and access your module-specific `Logger`.
    ///
    /// Below is a short code example on how to create and access your module-specific `Logger`.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.logger)
    ///     var logger
    ///
    ///     func configure() {
    ///         logger.info("\(Self.self) is getting configured...")
    ///     }
    /// }
    /// ```
    public var logger: Logger {
        if let module = Spezi.moduleInitContext {
            return Logger(subsystem: "edu.stanford.spezi.modules", category: module.loggerCategory)
        }
        return Spezi.logger
    }
}
