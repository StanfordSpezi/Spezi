//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import OrderedCollections
import OSLog
import SpeziFoundation
import SwiftUI
import XCTRuntimeAssertions


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
public final class Spezi: Sendable {
    static let logger = Logger(subsystem: "edu.stanford.spezi", category: "Spezi")

    @TaskLocal static var moduleInitContext: ModuleDescription?

    let standard: any Standard

    /// A shared repository to store any `KnowledgeSource`s restricted to the ``SpeziAnchor``.
    ///
    /// Every `Module` automatically conforms to `KnowledgeSource` and is stored within this storage object.
    fileprivate(set) nonisolated(unsafe) var storage: SpeziStorage // nonisolated, writes are all isolated to @MainActor, just reads are non-isolated

    /// Key is either a UUID for `@Modifier` or `@Model` property wrappers, or a `ModuleReference` for `EnvironmentAccessible` modifiers.
    @MainActor private var _viewModifiers: OrderedDictionary<AnyHashable, any ViewModifier> = [:]

    /// Array of all SwiftUI `ViewModifiers` collected using `_ModifierPropertyWrapper` from the configured ``Module``s.
    ///
    /// Any changes to this property will cause a complete re-render of the SwiftUI view hierarchy. See `SpeziViewModifier`.
    @MainActor var viewModifiers: [any ViewModifier] {
        _viewModifiers
            // View modifiers of inner-most modules are added first due to the dependency order.
            // However, we want view modifiers of dependencies to be available for inside view modifiers of the parent
            // (e.g., ViewModifier should be able to require the @Environment(...) value of the @Dependency).
            // This is why we need to reverse the order here.
            .reversed()
            .reduce(into: []) { partialResult, entry in
                partialResult.append(entry.value)
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
    @MainActor public var lifecycleHandler: [LifecycleHandler] {
        modules.compactMap { module in
            module as? LifecycleHandler
        }
    }

    @MainActor var notificationTokenHandler: [NotificationTokenHandler] {
        modules.compactMap { module in
            module as? NotificationTokenHandler
        }
    }

    @MainActor var notificationHandler: [NotificationHandler] {
        modules.compactMap { module in
            module as? NotificationHandler
        }
    }
    
    @MainActor var modules: [any Module] {
        storage.collect(allOf: (any AnyStoredModules).self)
            .reduce(into: []) { partialResult, modules in
                partialResult.append(contentsOf: modules.anyModules)
            }
    }

    @MainActor private var implicitlyCreatedModules: Set<ModuleReference> {
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
    

    @MainActor
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
    @MainActor
    public init(
        standard: any Standard,
        modules: [any Module],
        storage: consuming SpeziStorage = SpeziStorage()
    ) {
        self.standard = standard
        self.storage = consume storage

        self.loadModules(modules, ownership: .spezi)
        // load standard separately, such that all module loading takes precedence
        self.loadModule(standard, ownership: .spezi)
    }
    
    /// Load a new Module.
    ///
    /// Loads a new Spezi ``Module`` resolving all dependencies.
    /// - Note: Trying to load the same ``Module`` instance multiple times results in a runtime crash.
    ///
    /// - Important: While ``Module/Modifier`` and ``Module/Model`` properties and the ``EnvironmentAccessible`` protocol
    ///     are generally supported with dynamically loaded Modules, they will cause the global SwiftUI view hierarchy to re-render.
    ///     This might be undesirable und will cause interruptions. Therefore, avoid dynamically loading Modules with these properties.
    ///
    /// - Parameters:
    ///   - module: The new Module instance to load.
    ///   - ownership: Define the type of ownership when loading the module.
    ///
    /// ## Topics
    /// ### Ownership
    /// - ``ModuleOwnership``
    @MainActor
    public func loadModule(_ module: any Module, ownership: ModuleOwnership = .spezi) {
        loadModules([module], ownership: ownership)
    }

    @MainActor
    private func loadModules(_ modules: [any Module], ownership: ModuleOwnership) {
        precondition(Self.moduleInitContext == nil, "Modules cannot be loaded within the `configure()` method.")

        purgeWeaklyReferenced()

        let requestedModules = Set(modules.map { ModuleReference($0) })
        logger.debug("Loading module(s) \(modules.map { "\(type(of: $0))" }.joined(separator: ", ")) ...")


        let existingModules = self.modules

        let dependencyManager = DependencyManager(modules, existing: existingModules)
        dependencyManager.resolve()

        implicitlyCreatedModules.formUnion(dependencyManager.implicitlyCreatedModules)
        
        // we pass through the whole list of modules once to collect all @Provide values
        for module in dependencyManager.initializedModules {
            Self.$moduleInitContext.withValue(module.moduleDescription) {
                module.collectModuleValues(into: &storage)
            }
        }
        
        for module in dependencyManager.initializedModules {
            if requestedModules.contains(ModuleReference(module)) {
                // the policy only applies to the requested modules, all other are always managed and owned by Spezi
                self.initModule(module, ownership: ownership)
            } else {
                self.initModule(module, ownership: .spezi)
            }
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
    @MainActor
    public func unloadModule(_ module: any Module) {
        precondition(Self.moduleInitContext == nil, "Modules cannot be unloaded within the `configure()` method.")

        purgeWeaklyReferenced()

        guard module.isLoaded(in: self) else {
            return // module is not loaded
        }

        logger.debug("Unloading module \(type(of: module)) ...")

        let dependents = retrieveDependingModules(module.dependencyReference, considerOptionals: false)
        precondition(dependents.isEmpty, "Tried to unload Module \(type(of: module)) that is still required by peer Modules: \(dependents)")
        
        module.clearModule(from: self)
        
        implicitlyCreatedModules.remove(ModuleReference(module))

        // this check is important. Change to viewModifiers re-renders the whole SwiftUI view hierarchy. So avoid to do it unnecessarily
        if _viewModifiers[ModuleReference(module)] != nil {
            var keys: Set<AnyHashable> = [ModuleReference(module)]
            keys.formUnion(module.viewModifierEntires.map { $0.0 })

            // remove all at once
            _viewModifiers.removeAll { entry in
                keys.contains(entry.key)
            }
        }

        // re-injecting all dependencies ensures that the unloaded module is cleared from optional Dependencies from
        // pre-existing Modules.
        let dependencyManager = DependencyManager([], existing: modules)
        dependencyManager.resolve()

        module.clear() // automatically removes @Provide values and recursively unloads implicitly created modules
    }

    /// Initialize a Module.
    ///
    /// Call this method to initialize a Module, injecting necessary information into Spezi property wrappers.
    ///
    /// - Parameters:
    ///   - module: The module to initialize.
    ///   - ownership: Define the type of ownership when loading the module.
    @MainActor
    private func initModule(_ module: any Module, ownership: ModuleOwnership) {
        precondition(!module.isLoaded(in: self), "Tried to initialize Module \(type(of: module)) that was already loaded!")

        Self.$moduleInitContext.withValue(module.moduleDescription) {
            module.inject(spezi: self)

            // supply modules values to all @Collect
            module.injectModuleValues(from: storage)

            module.configure()

            switch ownership {
            case .spezi:
                module.storeModule(into: self)
            case .external:
                module.storeWeakly(into: self)
            }

            // If a module is @Observable, we automatically inject it view the `ModelModifier` into the environment.
            if let observable = module as? EnvironmentAccessible {
                // we can't guarantee weak references for EnvironmentAccessible modules
                precondition(ownership != .external, "Modules loaded with self-managed policy cannot conform to `EnvironmentAccessible`.")
                _viewModifiers[ModuleReference(module)] = observable.viewModifier
            }

            let modifierEntires: [(id: UUID, modifier: any ViewModifier)] = module.viewModifierEntires
            // this check is important. Change to viewModifiers re-renders the whole SwiftUI view hierarchy. So avoid to do it unnecessarily
            if !modifierEntires.isEmpty {
                for entry in modifierEntires.reversed() { // reversed, as we re-reverse things in the `viewModifier` getter
                    _viewModifiers.updateValue(entry.modifier, forKey: entry.id)
                }
            }
        }
    }

    /// Determine if a application property is stored as a copy in a `@Application` property wrapper.
    func createsCopy<Value>(_ keyPath: KeyPath<Spezi, Value>) -> Bool {
        keyPath == \.logger // loggers are created per Module.
    }

    @MainActor
    private func retrieveDependingModules(_ dependency: DependencyReference, considerOptionals: Bool) -> [any Module] {
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

    @MainActor
    func handleDependencyUninjection<M: Module>(of dependency: M) {
        let dependencyReference = dependency.dependencyReference

        guard implicitlyCreatedModules.contains(dependencyReference.reference) else {
            // we only recursively unload modules that have been created implicitly
            return
        }

        guard retrieveDependingModules(dependencyReference, considerOptionals: true).isEmpty else {
            return
        }

        unloadModule(dependency)
    }

    @MainActor
    func handleCollectedValueRemoval<Value>(for id: UUID, of type: Value.Type) {
        var entries = storage[CollectedModuleValues<Value>.self]
        let removed = entries.removeValue(forKey: id)
        guard removed != nil else {
            return
        }

        storage[CollectedModuleValues<Value>.self] = entries

        for module in modules {
            module.injectModuleValues(from: storage)
        }
    }

    @MainActor
    func handleViewModifierRemoval(for id: UUID) {
        if _viewModifiers[id] != nil {
            _viewModifiers.removeValue(forKey: id)
        }
    }

    func retrieveDependencyReplacement<M: Module>(for type: M.Type) -> M? {
        guard let storedModules = storage[StoredModulesKey<M>.self] else {
            return nil
        }

        let replacement = storedModules.retrieveFirstAvailable()
        storedModules.removeNilReferences(in: &storage) // if we ask for a replacement, there is opportunity to clean up weak reference objects
        return replacement
    }

    /// Iterates through weakly referenced modules and purges any nil references.
    ///
    /// These references are purged lazily. This is generally no problem because the overall overhead will be linear.
    /// If you load `n` modules with self-managed storage policy and then all `n` modules will eventually be deallocated, there might be `n` weak references still stored
    /// till the next module interaction is performed (e.g., new module is loaded or unloaded).
    private func purgeWeaklyReferenced() {
        storage
            .collect(allOf: (any AnyStoredModules).self)
            .forEach { storedModules in
                storedModules.removeNilReferences(in: &storage)
            }
    }
}


extension Module {
    @MainActor
    fileprivate func storeModule(into spezi: Spezi) {
        storeDynamicReference(.element(self), into: spezi)
    }

    @MainActor
    fileprivate func storeWeakly(into spezi: Spezi) {
        storeDynamicReference(.weakElement(self), into: spezi)
    }

    @MainActor
    fileprivate func storeDynamicReference(_ module: DynamicReference<Self>, into spezi: Spezi) {
        if spezi.storage.contains(StoredModulesKey<Self>.self) {
            // swiftlint:disable:next force_unwrapping
            spezi.storage[StoredModulesKey<Self>.self]!.updateValue(module, forKey: self.reference)
        } else {
            spezi.storage[StoredModulesKey<Self>.self] = StoredModulesKey(module, forKey: reference)
        }
    }

    @MainActor
    fileprivate func isLoaded(in spezi: Spezi) -> Bool {
        guard let storedModules = spezi.storage[StoredModulesKey<Self>.self] else {
            return false
        }
        return storedModules.contains(reference)
    }

    @MainActor
    fileprivate func clearModule(from spezi: Spezi) {
        guard var storedModules = spezi.storage[StoredModulesKey<Self>.self] else {
            return
        }
        storedModules.removeValue(forKey: reference)

        if storedModules.isEmpty {
            spezi.storage[StoredModulesKey<Self>.self] = nil
        } else {
            spezi.storage[StoredModulesKey<Self>.self] = storedModules
        }
    }
}
