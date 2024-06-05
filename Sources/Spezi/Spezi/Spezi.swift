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
/// This represents the central ``Spezi/Spezi`` storage module.
@_documentation(visibility: internal)
public typealias SpeziStorage = ValueRepository<SpeziAnchor>


private struct ImplicitlyCreatedModulesKey: DefaultProvidingKnowledgeSource {
    typealias Value = Set<ModuleReference>
    typealias Anchor = SpeziAnchor

    static let defaultValue: Value = []
}


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
/// ### Dynamically Loading Modules
///
/// While the above examples demonstrated how Modules are configured within your ``SpeziAppDelegate``, they can also be loaded and unloaded dynamically based on demand.
/// To do so you, you need to access the global `Spezi` instance from within your Module.
///
/// Below is a short code example:
/// ```swift
/// class ExampleModule: Module {
///     @Application(\.spezi)
///     var spezi
///
///     func userAuthenticated() {
///         spezi.loadModule(AccountManagement())
///         // ...
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
/// - ``logger``
/// - ``launchOptions``
/// - ``spezi``
///
/// ### Actions
/// - ``registerRemoteNotifications``
/// - ``unregisterRemoteNotifications``
@Observable
public class Spezi {
    static let logger = Logger(subsystem: "edu.stanford.spezi", category: "Spezi")
    
    @TaskLocal static var moduleInitContext: (any Module)?
    
    let standard: any Standard
    /// A shared repository to store any `KnowledgeSource`s restricted to the ``SpeziAnchor``.
    ///
    /// Every `Module` automatically conforms to `KnowledgeSource` and is stored within this storage object.
    fileprivate(set) var storage: SpeziStorage

    private var _viewModifiers: [ModuleReference: [any ViewModifier]] = [:]

    /// Array of all SwiftUI `ViewModifiers` collected using `_ModifierPropertyWrapper` from the configured ``Module``s.
    ///
    /// Any changes to this property will cause a complete re-render of the SwiftUI view hierarchy. See `SpeziViewModifier`.
    var viewModifiers: [any ViewModifier] {
        _viewModifiers.reduce(into: []) { partialResult, entry in
            partialResult.append(contentsOf: entry.value)
        }
    }

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
    
    private var implicitlyCreatedModules: Set<ModuleReference> {
        get {
            storage[ImplicitlyCreatedModulesKey.self]
        }
        set {
            if newValue.isEmpty {
                storage[ImplicitlyCreatedModulesKey.self] = nil
            } else {
                storage[ImplicitlyCreatedModulesKey.self] = newValue
            }
        }
    }
    
    /// Access the global Spezi instance.
    ///
    /// Access the global Spezi instance using the ``Module/Application`` property wrapper inside your ``Module``.
    ///
    /// Below is a short code example on how to access the Spezi instance.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.spezi)
    ///     var spezi
    /// }
    /// ```
    public var spezi: Spezi {
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
        
        self.loadModules([self.standard] + modules)
    }
    
    /// Load a new Module.
    ///
    /// Loads a new Spezi ``Module`` resolving all dependencies.
    /// - Note: Trying to load the same ``Module`` instance multiple times results in a runtime crash.
    ///
    /// - Important: While ``Module/Modifier`` and ``Module/Model`` properties and the ``EnvironmentAccessible`` protocol
    ///     are generally supported with dynamically loaded Modules, they will cause the global SwiftUI view hierarchy to re-render.
    ///     This might be undesirable und will cause interruptions. Therefore, avoid dynamcially loading Modules with these properties.
    ///
    /// - Parameter module: The new Module instance to load.
    public func loadModule(_ module: any Module) {
        loadModules([module])
    }
    
    private func loadModules(_ modules: [any Module]) {
        precondition(Self.moduleInitContext == nil, "Modules cannot be loaded within the `configure()` method.")
        let existingModules = self.modules
        
        let dependencyManager = DependencyManager(modules, existing: existingModules)
        dependencyManager.resolve()
        
        implicitlyCreatedModules.formUnion(dependencyManager.implicitlyCreatedModules)
        
        // we pass through the whole list of modules once to collect all @Provide values
        for module in dependencyManager.initializedModules {
            Self.$moduleInitContext.withValue(module) {
                module.collectModuleValues(into: &storage)
            }
        }
        
        for module in dependencyManager.initializedModules {
            self.initModule(module)
        }
        
        
        // Newly loaded modules might have @Provide values that need to be updated in @Collect properties in existing modules.
        for existingModule in existingModules {
            existingModule.injectModuleValues(from: storage)
        }
    }
    
    /// Unload a Module.
    ///
    /// Unloads a ``Module`` from the Spezi system.
    /// - Important: Unloading a ``Module`` that is still required by other modules results in a runtime crash.
    ///     However, unloading a Module that is the **optional** dependency of another Module works.
    ///
    /// Unloading a Module will recursively unload its dependencies that were not loaded explicitly.
    ///
    /// - Parameter module: The Module to unload.
    public func unloadModule(_ module: any Module) {
        precondition(Self.moduleInitContext == nil, "Modules cannot be unloaded within the `configure()` method.")
        
        guard module.isLoaded(in: self) else {
            return // module is not loaded
        }
        
        let dependents = retrieveDependingModules(module)
        precondition(dependents.isEmpty, "Tried to unload Module \(type(of: module)) that is still required by peer Modules: \(dependents)")
        
        module.clearModule(from: self)
        
        implicitlyCreatedModules.remove(ModuleReference(module))
        
        removeCollectValues(for: module)

        // this check is important. Change to viewModifiers re-renders the whole SwiftUI view hierarchy. So avoid to do it unnecessarily
        if _viewModifiers[ModuleReference(module)] != nil {
            _viewModifiers[ModuleReference(module)] = nil
        }

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
                guard implicitlyCreatedModules.contains(ModuleReference(dependency)) else {
                    // we only recursively unload modules that have been created implicitly
                    continue
                }
                
                guard retrieveDependingModules(dependency).isEmpty else {
                    continue
                }
                
                unloadModule(dependency)
            }
        }
        
        module.clear()
    }
    
    private func removeCollectValues(for module: any Module) {
        let valueContainers = storage.collect(allOf: (any AnyCollectModuleValues).self)
        
        var changed = false
        for var container in valueContainers {
            let didChange = container.removeValues(from: module)
            guard didChange else {
                continue
            }
            
            changed = true
            container.store(into: &storage)
        }
        
        guard changed else {
            return
        }
        
        for module in modules {
            module.injectModuleValues(from: storage)
        }
    }

    /// Initialize a Module.
    ///
    /// Call this method to initialize a Module, injecting necessary information into Spezi property wrappers.
    ///
    /// - Parameters:
    ///   - module: The module to initialize.
    private func initModule(_ module: any Module) {
        precondition(!module.isLoaded(in: self), "Tried to initialize Module \(type(of: module)) that was already loaded!")

        Self.$moduleInitContext.withValue(module) {
            module.inject(spezi: self)

            // supply modules values to all @Collect
            module.injectModuleValues(from: storage)

            module.configure()
            module.storeModule(into: self)

            let viewModifiers = module.viewModifiers
            // this check is important. Change to viewModifiers re-renders the whole SwiftUI view hierarchy. So avoid to do it unnecessarily
            if !viewModifiers.isEmpty {
                _viewModifiers[ModuleReference(module), default: []].append(contentsOf: module.viewModifiers)
            }

            // If a module is @Observable, we automatically inject it view the `ModelModifier` into the environment.
            if let observable = module as? EnvironmentAccessible {
                _viewModifiers[ModuleReference(module), default: []].append(observable.viewModifier)
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
