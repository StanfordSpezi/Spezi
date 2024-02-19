//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import os
import SpeziFoundation
import SwiftUI


/// A ``SharedRepository`` implementation that is anchored to ``SpeziAnchor``.
///
/// This represents the central ``Spezi`` storage module.
@_documentation(visibility: internal)
public typealias SpeziStorage = HeapRepository<SpeziAnchor>

/// Open-source framework for rapid development of modern, interoperable digital health applications.
///
/// Set up the Spezi framework in your `App` instance of your SwiftUI application using the ``SpeziAppDelegate`` and the `@ApplicationDelegateAdaptor` property wrapper.
/// Use the `View.spezi(_: SpeziAppDelegate)` view modifier to apply your Spezi configuration to the main view in your SwiftUI `Scene`:
/// ```swift
/// import Spezi
/// import SwiftUI
///
///
/// @main
/// struct ExampleApp: App {
///     @ApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate
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
///
/// ## Topics
///
/// ### Properties
/// - ``logger``
/// - ``launchOptions``
///
/// ### Actions
/// - ``registerRemoteNotifications``
/// - ``unregisterRemoteNotifications``
public class Spezi {
    static let logger = Logger(subsystem: "edu.stanford.spezi", category: "Spezi")

    @TaskLocal static var moduleInitContext: (any Module)?

    /// A shared repository to store any ``KnowledgeSource``s restricted to the ``SpeziAnchor``.
    ///
    /// Every `Module` automatically conforms to `KnowledgeSource` and is stored within this storage object.
    fileprivate(set) var storage: SpeziStorage

    /// Array of all SwiftUI `ViewModifiers` collected using ``_ModifierPropertyWrapper`` from the configured ``Module``s.
    var viewModifiers: [any ViewModifier]

    /// A collection of ``Spezi/Spezi`` `LifecycleHandler`s.
    @available(
        *,
         deprecated,
         message: """
             Please use the new @Application property wrapper to access delegate functionality. \
             Otherwise use the SwiftUI onReceive(_:perform:) for UI related notifications.
             """
    )


    var lifecycleHandler: [LifecycleHandler] {
        storage.collect(allOf: LifecycleHandler.self)
    }

    var notificationTokenHandler: [NotificationTokenHandler] {
        storage.collect(allOf: NotificationTokenHandler.self)
    }

    var notificationHandler: [NotificationHandler] {
        storage.collect(allOf: NotificationHandler.self)
    }


    convenience init(from configuration: Configuration, storage: consuming SpeziStorage = SpeziStorage()) {
        self.init(standard: configuration.standard, modules: configuration.modules.elements, storage: storage)
    }
    
    init(
        standard: any Standard,
        modules: [any Module],
        storage: consuming SpeziStorage = SpeziStorage()
    ) {
        // mutable property, as StorageValueProvider has inout protocol requirement.
        var storage = consume storage
        var collectedModifiers: [any ViewModifier] = []

        let dependencyManager = DependencyManager(modules + [standard])
        dependencyManager.resolve()

        for module in dependencyManager.sortedModules {
            // we pass through the whole list of modules once to collect all @Provide values
            module.collectModuleValues(into: &storage)
        }

        self.storage = storage
        self.viewModifiers = [] // init all properties, we will store the final result later on

        for module in dependencyManager.sortedModules {
            Self.$moduleInitContext.withValue(module) {
                module.inject(standard: standard)
                module.inject(spezi: self)

                // supply modules values to all @Collect
                module.injectModuleValues(from: self.storage)

                module.configure()
                module.storeModule(into: self)

                collectedModifiers.append(contentsOf: module.viewModifiers)

                // If a module is @Observable, we automatically inject it view the `ModelModifier` into the environment.
                if let observable = module as? EnvironmentAccessible {
                    collectedModifiers.append(observable.viewModifier)
                }
            }
        }

        self.viewModifiers = collectedModifiers
    }


    func createsCopy<Value>(_ keyPath: KeyPath<Spezi, Value>) -> Bool {
        keyPath == \.logger // loggers are created per Module.
    }
}


extension Module {
    func storeModule(into spezi: Spezi) {
        guard let value = self as? Value else {
            spezi.logger.warning("Could not store \(Self.self) in the SpeziStorage as the `Value` typealias was modified.")
            return
        }
        spezi.storage[Self.self] = value
    }
}
