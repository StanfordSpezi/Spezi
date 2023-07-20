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
/// This represents the central ``Spezi`` storage component.
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
/// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` propert.
/// ```swift
/// import Spezi
///
///
/// class TemplateAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: ExampleStandard()) {
///             // Add your `Component`s here ...
///        }
///     }
/// }
/// ```
///
/// The ``Component`` documentation provides more information about the structure of components.
/// Refer to the ``Configuration`` documentation to learn more about the Spezi configuration.
public actor Spezi<S: Standard>: AnySpezi, ObservableObject {
    /// A shared repository to store any ``KnowledgeSource``s restricted to the ``SpeziAnchor``.
    public let storage: SpeziStorage
    /// Logger used to log events in the ``Spezi/Spezi`` instance.
    public let logger: Logger
    /// The ``Standard`` used in the ``Spezi/Spezi`` instance.
    public let standard: S
    
    
    init(
        standard: S,
        components: [any Component]
    ) {
        // mutable property, as StorageValueProvider has inout protocol requirement.
        var storage = SpeziStorage()

        self.logger = storage[SpeziLogger.self]
        self.standard = standard
        
        var componentsAndStandard = components
        componentsAndStandard.append(standard)

        let dependencyManager = DependencyManager(componentsAndStandard)
        dependencyManager.resolve()

        for component in dependencyManager.sortedComponents {
            // we pass through the whole list of components once to collect all @Provide values
            component.collectComponentValues(into: &storage)
        }
        
        for component in dependencyManager.sortedComponents {
            component.inject(standard: standard)
            // supply components values to all @Collect
            component.injectComponentValues(from: storage)

            component.configure()
            component.storeComponent(into: &storage)
        }

        self.storage = storage
    }
}


extension Component {
    func storeComponent<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        guard let value = self as? Value else {
            repository[SpeziLogger.self].warning("Could not store \(Self.self) in the SpeziStorage as the `Value` typealias was modified.")
            return
        }
        repository[Self.self] = value
    }
}
