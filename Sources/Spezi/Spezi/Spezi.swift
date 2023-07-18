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
public typealias SpeziStorage = HeapRepository<SpeziAnchor> // TODO custom implementation with shutdown handler?

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
/// Register your different ``Component``s (or more sophisticated ``Module``s) using the ``SpeziAppDelegate/configuration`` property, e.g., using the
/// `FHIR` standard integrated into the Spezi framework:
/// ```swift
/// import Spezi
/// import FHIR
///
///
/// class TemplateAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
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
        components: [any Component<S>],
        _ logger: Logger = Logger(subsystem: "edu.stanford.spezi", category: "spezi")
    ) {
        // mutable property, as StorageValueProvider has inout protocol requirement.
        var storage = SpeziStorage()

        self.logger = logger
        self.standard = standard
        
        var componentsAndStandard = components
        componentsAndStandard.append(standard)

        let dependencyManager = DependencyManager(componentsAndStandard)
        dependencyManager.resolve()

        for component in dependencyManager.sortedComponents {
            component.inject(standard: standard)

            // TODO should we allow for any registration steps?
            //  => standard specific stuff?

            // we pass through the whole list of components once to collect all @Provide values
            component.collectComponentValues(into: &storage)
        }
        
        for component in dependencyManager.sortedComponents {
            // supply components values to all @Collect
            component.injectComponentValues(from: storage)

            component.configure()
            component.storeComponent(into: &storage)
        }

        self.storage = storage
        
        standard.inject(dataStorageProviders: dataStorageProviders)
    }
}
