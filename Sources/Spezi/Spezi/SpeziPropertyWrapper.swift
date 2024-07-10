//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


protocol SpeziPropertyWrapper {
    /// Inject the global Spezi instance.
    ///
    /// This call happens right before ``Module/configure()-5pa83`` is called.
    /// An empty default implementation is provided.
    /// - Parameter spezi: The global ``Spezi/Spezi`` instance.
    @MainActor
    func inject(spezi: Spezi)

    /// Clear the property wrapper state before the Module is unloaded.
    @MainActor
    func clear()
}


extension SpeziPropertyWrapper {
    func inject(spezi: Spezi) {}
}


extension Module {
    @MainActor
    func inject(spezi: Spezi) {
        for wrapper in retrieveProperties(ofType: SpeziPropertyWrapper.self) {
            wrapper.inject(spezi: spezi)
        }
    }

    @MainActor
    func clear() {
        for wrapper in retrieveProperties(ofType: SpeziPropertyWrapper.self) {
            wrapper.clear()
        }
    }
}
