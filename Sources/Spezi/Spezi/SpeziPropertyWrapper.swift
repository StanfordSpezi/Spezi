//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


protocol SpeziPropertyWrapper {
    func inject(spezi: Spezi)
}


extension Module {
    func inject(spezi: Spezi) {
        for wrapper in retrieveProperties(ofType: SpeziPropertyWrapper.self) {
            wrapper.inject(spezi: spezi)
        }
    }
}
