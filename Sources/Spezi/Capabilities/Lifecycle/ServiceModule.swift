//
// This source file is part of the Stanford XCTestExtensions open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// A Module that hooks into the structured concurrency service lifecycle of the application.
public protocol ServiceModule: Module, Sendable {
    /// Runs the service module.
    ///
    /// This task is executed as a child task of the SwiftUI App lifecycle. The task is cancelled once the app is about to terminate.
    func run() async
}


extension ServiceModule {
    var moduleId: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}

