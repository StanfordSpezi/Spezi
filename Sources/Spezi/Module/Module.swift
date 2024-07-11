//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation


// note: detailed documentation is provided as an article extension in the DocC bundle
/// A `Module` defines a software subsystem that can be configured as part of the ``SpeziAppDelegate/configuration``.
public protocol Module: AnyObject, KnowledgeSource<SpeziAnchor> {
    /// Called on the initialization of the Spezi instance to perform a lightweight configuration of the module.
    ///
    /// It is advised that longer setup tasks are done in an asynchronous task and started during the call of the configure method.
    @MainActor
    func configure()
}


extension Module {
    /// Empty configuration method.
    ///
    /// No operation.
    public func configure() {}
}
