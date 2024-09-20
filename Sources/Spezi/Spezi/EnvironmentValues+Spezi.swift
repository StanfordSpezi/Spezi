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

    var spezi: Spezi? {
        get {
            self[SpeziKey.self]
        }
        set {
            self[SpeziKey.self] = newValue
        }
    }
}
