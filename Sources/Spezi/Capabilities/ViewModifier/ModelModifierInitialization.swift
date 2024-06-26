//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import SwiftUI


struct ModelModifierInitialization<Model: Observable & AnyObject>: ViewModifierInitialization, @unchecked Sendable {
    // @uncheked Sendable is fine as we are never allowing to mutate the non-Sendable `Model`.
    // The `Model` will be passed to the MainActor (and be accessible from the SwiftUI environment). Those interactions
    // are out of scope and expected to be handled by the Application developer (typically Model will be fully MainActor isolated anyways).
    // We just make sure with this wrapper that no interaction can happen till the Model arrives on the MainActor.
    private let model: Model

    init(model: Model) {
        self.model = model
    }

    func initializeModifier() -> some ViewModifier {
        ModelModifier(model: model)
    }
}
