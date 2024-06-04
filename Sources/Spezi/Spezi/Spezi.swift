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
import XCTRuntimeAssertions


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
@Observable
public class Spezi {
    static let logger = Logger(subsystem: "edu.stanford.spezi", category: "Spezi")

    @TaskLocal static var moduleInitContext: (any Module)?

    let standard: any Standard
    /// A shared repository to store any ``KnowledgeSource``s restricted to the ``SpeziAnchor``.
    ///
    /// Every `Module` automatically conforms to `KnowledgeSource` and is stored within this storage object.
    @ObservationIgnored fileprivate(set) var storage: SpeziStorage

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


    @_spi(Spezi)
    public var lifecycleHandler: [LifecycleHandler] {
        storage.collect(allOf: LifecycleHandler.self)
    }

    var notificationTokenHandler: [NotificationTokenHandler] {
        storage.collect(allOf: NotificationTokenHandler.self)
    }

    var notificationHandler: [NotificationHandler] {
        storage.collect(allOf: NotificationHandler.self)
    }

    var modules: [any Module] {
        storage.collect(allOf: (any Module).self)
    }

    /// Access the global Spezi instance.
    public var spezi: Spezi { // TODO: example via @Application property wrapper, docs
        // this seems nonsensical, but is essential to support Spezi access from the @Application modifier
        self
    }


    convenience init(from configuration: Configuration, storage: consuming SpeziStorage = SpeziStorage()) {
        self.init(standard: configuration.standard, modules: configuration.modules.elements, storage: storage)
    }
    

    /// Create a new Spezi instance.
    ///
    /// - Parameters:
    ///   - standard: The standard to use.
    ///   - modules: The collection of modules to initialize.
    ///   - storage: Optional, initial storage to inject.
    @_spi(Spezi)
    public init(
        standard: any Standard,
        modules: [any Module],
        storage: consuming SpeziStorage = SpeziStorage()
    ) {
        self.standard = standard
        self.storage = consume storage
        self.viewModifiers = []

        self.loadModules([self.standard] + modules)
    }

    public func loadModule(_ module: any Module) {
        loadModules([module])
    }

    private func loadModules(_ modules: [any Module]) { // TODO: docs
        let existingModules = self.modules

        let dependencyManager = DependencyManager(modules, existing: existingModules)
        dependencyManager.resolve()

        // TODO: make sure this has Set semantics!
        var implicitlyCreatedModules = storage[ModuleReferences.self]
        implicitlyCreatedModules.append(contentsOf: dependencyManager.implicitlyCreatedModules)
        storage[ModuleReferences.self] = implicitlyCreatedModules

        for module in dependencyManager.initializedModules {
            // we pass through the whole list of modules once to collect all @Provide values
            module.collectModuleValues(into: &storage)
        }

        for module in dependencyManager.initializedModules {
            self.initModule(module)
        }


        // Newly loaded modules might have @Provide values that need to be updated in @Collect properties in existing modules.
        for existingModule in existingModules {
            // TODO: do we really want to support that?, that gets super chaotic with unload modules???
            // TODO: create an issue to have e.g. update functionality (rework that whole thing?), remove that system altogether?
            existingModule.injectModuleValues(from: storage)
        }
    }

    public func unloadModule(_ module: any Module) { // TODO: docs
        guard module.isLoaded(in: self) else {
            return // module is not loaded
        }

        let dependents = retrieveDependingModules(module)
        precondition(dependents.isEmpty, "Tried to unload Module \(type(of: module)) that is still required by peer Modules: \(dependents)")

        module.clearModule(from: self)

        // TODO: this is complicated boi!!
        if storage[ModuleReferences.self].contains(ModuleReference(module)) {
            var implicitlyCreatedModules = storage[ModuleReferences.self]
            implicitlyCreatedModules.removeAll(where: { $0 == ModuleReference(module) })
            storage[ModuleReferences.self] = implicitlyCreatedModules
        }

        // TODO: remove @Collect values that were previously provided by this Module

        // re-injecting all dependencies ensures that the unloaded module is cleared from optional Dependencies from
        // pre-existing Modules.
        let dependencyManager = DependencyManager([], existing: modules)
        dependencyManager.resolve()


        // Check if we need to unload additional modules that were not explicitly created.
        // For example a explicitly loaded Module might have recursive @Dependency declarations that are automatically loaded.
        // Such modules are unloaded as well if they are no longer required.
        for dependencyDeclaration in module.dependencyDeclarations {
            let dependencies = dependencyDeclaration.injectedDependencies
            for dependency in dependencies {
                // TODO: accessor naming!
                guard storage[ModuleReferences.self].contains(ModuleReference(dependency)) else {
                    continue // TODO: docs!
                }

                guard retrieveDependingModules(dependency).isEmpty else {
                    continue
                }

                unloadModule(dependency)
            }
        }
    }

    /// Initialize a Module.
    ///
    /// Call this method to initialize a Module, injecting necessary information into Spezi property wrappers.
    ///
    ///
    /// - Parameters:
    ///   - module:
    ///   - standard:
    private func initModule(_ module: any Module) { // TODO: docs
        precondition(!module.isLoaded(in: self), "Tried to initialize Module \(type(of: module)) that was already loaded!")

        Self.$moduleInitContext.withValue(module) {
            module.inject(spezi: self)

            // supply modules values to all @Collect
            module.injectModuleValues(from: storage)

            module.configure()
            module.storeModule(into: self)

            viewModifiers.append(contentsOf: module.viewModifiers)

            // If a module is @Observable, we automatically inject it view the `ModelModifier` into the environment.
            if let observable = module as? EnvironmentAccessible {
                viewModifiers.append(observable.viewModifier)
            }
        }
    }

    /// Determine if a application property is stored as a copy in a `@Application` property wrapper.
    func createsCopy<Value>(_ keyPath: KeyPath<Spezi, Value>) -> Bool {
        keyPath == \.logger // loggers are created per Module.
    }

    private func retrieveDependingModules(_ dependency: any Module, considerOptionals: Bool = false) -> [any Module] {
        var result: [any Module] = []

        for module in modules {
            switch module.dependencyRelation(to: dependency) {
            case .dependent:
                result.append(module)
            case .optional:
                if considerOptionals {
                    result.append(module)
                }
            case .unrelated:
                continue
            }
        }

        return result
    }
}


extension Module {
    fileprivate func storeModule(into spezi: Spezi) {
        guard let value = self as? Value else {
            spezi.logger.warning("Could not store \(Self.self) in the SpeziStorage as the `Value` typealias was modified.")
            return
        }
        spezi.storage[Self.self] = value
    }

    fileprivate func isLoaded(in spezi: Spezi) -> Bool {
        spezi.storage[Self.self] != nil
    }

    fileprivate func clearModule(from spezi: Spezi) {
        spezi.storage[Self.self] = nil
    }
}
