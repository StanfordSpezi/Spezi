//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SwiftUI


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
    /// A typesafe typedCollection of different elements of an ``Spezi/Spezi`` instance.
    public let typedCollection: TypedCollection
    /// Logger used to log events in the ``Spezi/Spezi`` instance.
    public let logger: Logger
    /// The ``Standard`` used in the ``Spezi/Spezi`` instance.
    public let standard: S
    
    
    init(
        standard: S,
        components: [any Component<S>],
        _ logger: Logger = Logger(subsystem: "edu.stanford.spezi", category: "spezi")
    ) {
        self.logger = logger
        self.typedCollection = TypedCollection(logger: logger)
        self.standard = standard
        
        var componentsAndStandard = components
        componentsAndStandard.append(standard)
        
        let sortedComponents = DependencyManager(componentsAndStandard).sortedComponents
        
        for component in sortedComponents {
            component.inject(standard: standard)
            component.configure()
            component.saveInTypedCollection(spezi: self)
        }
        
        standard.inject(dataStorageProviders: dataStorageProviders)
    }
}
