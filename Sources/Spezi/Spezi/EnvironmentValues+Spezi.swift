//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


extension EnvironmentValues {
    private struct SpeziKey: EnvironmentKey {
        static let defaultValue: Spezi? = nil
    }
    
    /// Access the Spezi instance to provide additional support for the SwiftUI environment.
    ///
    /// Use this property as a basis for your own
    var spezi: Spezi? { // TODO: we do not really need this?
        get {
            self[SpeziKey.self]
        }
        set {
            self[SpeziKey.self] = newValue
        }
    }
}
