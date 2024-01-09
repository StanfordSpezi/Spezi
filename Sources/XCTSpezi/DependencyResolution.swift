//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
@_implementationOnly import SwiftUI


/// Configure and resolve the dependency tree for a collection of [`Module`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/module)s.
///
/// This method can be used in unit test to resolve dependencies and properly initialize a set of Spezi `Module`s.
///
/// - Parameters:
///   - standard: The Spezi [`Standard`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/standard) to initialize.
///   - simulateLifecycle: Options to simulate behavior for [`LifecycleHandler`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/lifecyclehandler)s.
///   - modules: The collection of Modules that are configured.
public func withDependencyResolution<S: Standard>(
    standard: S,
    simulateLifecycle: LifecycleSimulationOptions = .disabled,
    @ModuleBuilder _ modules: () -> ModuleCollection
) {
    let spezi = Spezi(standard: standard, modules: modules().elements)

    if case let .launchWithOptions(options) = simulateLifecycle {
        spezi.lifecycleHandler.willFinishLaunchingWithOptions(UIApplication.shared, launchOptions: options)
    }
}

/// Configure and resolve the dependency tree for a collection of [`Module`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/module)s.
///
/// This method can be used in unit test to resolve dependencies and properly initialize a set of Spezi `Module`s.
///
/// - Parameters:
///   - simulateLifecycle: Options to simulate behavior for [`LifecycleHandler`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/lifecyclehandler)s.
///   - modules: The collection of Modules that are configured.
public func withDependencyResolution(
    simulateLifecycle: LifecycleSimulationOptions = .disabled,
    @ModuleBuilder _ modules: () -> ModuleCollection
) {
    withDependencyResolution(standard: DefaultStandard(), simulateLifecycle: simulateLifecycle, modules)
}
