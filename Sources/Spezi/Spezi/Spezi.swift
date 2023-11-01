//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import os
import SwiftUI


/// A ``SharedRepository`` implementation that is anchored to ``SpeziAnchor``.
///
/// This represents the central ``Spezi`` storage module.
public typealias SpeziStorage = HeapRepository<SpeziAnchor>

/// Open-source framework for rapid development of modern, interoperable digital health applications.
///
/// Set up the Spezi framework in your `App` instance of your SwiftUI application using the ``SpeziAppDelegate`` and the `@UIApplicationDelegateAdaptor` property wrapper.
/// Use the `View.spezi(_: SpeziAppDelegate)` view modifier to apply your Spezi configuration to the main view in your SwiftUI `Scene`:
/// ```swift
/// import Spezi
/// import SwiftUI
///
///
/// @main
/// struct ExampleApp: App {
///     @UIApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate
///
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .spezi(appDelegate)
///         }
///     }
/// }
/// ```
///
/// Register your different ``Module``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property.
/// ```swift
/// import Spezi
///
///
/// class TemplateAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: ExampleStandard()) {
///             // Add your `Module`s here ...
///        }
///     }
/// }
/// ```
///
/// The ``Module`` documentation provides more information about the structure of modules.
/// Refer to the ``Configuration`` documentation to learn more about the Spezi configuration.
public actor Spezi<S: Standard>: AnySpezi {
    /// A shared repository to store any ``KnowledgeSource``s restricted to the ``SpeziAnchor``.
    public let storage: SpeziStorage
    /// Logger used to log events in the ``Spezi/Spezi`` instance.
    public let logger: Logger
    /// The ``Standard`` used in the ``Spezi/Spezi`` instance.
    public let standard: S

    /// Array of all SwiftUI `ViewModifiers` collected using ``_ModifierPropertyWrapper`` from the configured ``Module``s.
    let viewModifiers: [any ViewModifier]

    
    init(
        standard: S,
        modules: [any Module]
    ) {
        // mutable property, as StorageValueProvider has inout protocol requirement.
        var storage = SpeziStorage()
        var collectedModifiers: [any ViewModifier] = []

        self.logger = storage[SpeziLogger.self]
        self.standard = standard

        let dependencyManager = DependencyManager(modules + [standard])
        dependencyManager.resolve()

        for module in dependencyManager.sortedModules {
            // we pass through the whole list of modules once to collect all @Provide values
            module.collectModuleValues(into: &storage)
        }
        
        for module in dependencyManager.sortedModules {
            module.inject(standard: standard)
            // supply modules values to all @Collect
            module.injectModuleValues(from: storage)

            module.configure()
            module.storeModule(into: &storage)

            collectedModifiers.append(contentsOf: module.viewModifiers)
        }

        self.storage = storage
        self.viewModifiers = collectedModifiers
    }
}


extension Module {
    func storeModule<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        guard let value = self as? Value else {
            repository[SpeziLogger.self].warning("Could not store \(Self.self) in the SpeziStorage as the `Value` typealias was modified.")
            return
        }
        repository[Self.self] = value
    }
}
