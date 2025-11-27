//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(SwiftUI)
import Spezi
import SpeziTesting


/// Legacy implementation.
@MainActor
@available(*, deprecated, message: "Please migrate to the 'SpeziTesting' library.")
public func withDependencyResolution<S: Standard>(
    standard: S,
    simulateLifecycle: LifecycleSimulationOptions = .disabled,
    @ModuleBuilder _ modules: () -> ModuleCollection
) {
    SpeziTesting.withDependencyResolution(standard: standard, simulateLifecycle: simulateLifecycle, modules)
}

/// Legacy implementation.
@MainActor
@available(*, deprecated, message: "Please migrate to the 'SpeziTesting' library.")
public func withDependencyResolution(
    simulateLifecycle: LifecycleSimulationOptions = .disabled,
    @ModuleBuilder _ modules: () -> ModuleCollection
) {
    SpeziTesting.withDependencyResolution(simulateLifecycle: simulateLifecycle, modules)
}
#endif
