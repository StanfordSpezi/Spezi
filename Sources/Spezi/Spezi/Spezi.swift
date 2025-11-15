//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT

import SwiftUI
@_spi(APISupport) import SpeziCore
@_exported import SpeziCore


extension Spezi {
    @MainActor package var lifecycleHandler: [any LifecycleHandler] {
        modules.compactMap { module in
            module as? any LifecycleHandler
        }
    }

    @MainActor var notificationTokenHandler: [any NotificationTokenHandler] {
        modules.compactMap { module in
            module as? any NotificationTokenHandler
        }
    }

    @MainActor var notificationHandler: [any NotificationHandler] {
        modules.compactMap { module in
            module as? any NotificationHandler
        }
    }
    
    @MainActor
    func handleViewModifierRemoval(for id: UUID) {
        if _viewModifiers[id] != nil {
            _viewModifiers.removeValue(forKey: id)
        }
    }
}
