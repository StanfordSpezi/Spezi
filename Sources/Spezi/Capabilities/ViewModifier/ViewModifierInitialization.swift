//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import SwiftUI


/// Capture the possibility to initialize a `ViewModifier`.
///
/// With Swift 6, even the ViewModifier initializers are isolated to MainActor. Therefore, we need to delay initialization
/// of ViewModifiers to the point where we are on the MainActor.
protocol ViewModifierInitialization: Sendable {
    associatedtype Modifier: ViewModifier

    @MainActor
    func initializeModifier() -> Modifier
}
