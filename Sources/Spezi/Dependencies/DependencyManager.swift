//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Gather information about modules with dependencies.
@MainActor
public class DependencyManager: Sendable {
    /// Collection of already initialized modules.
    private let existingModules: [any Module]
    /// We track the top level module instances to resolve the order for initialization.
    private let originalModules: [any Module]

    /// Collection of initialized Modules.
    ///
    /// Order is determined by the dependency tree. This represents the result of the dependency resolution process.
    private(set) var initializedModules: [any Module]
    /// List of implicitly created Modules.
    ///
    /// A List of `ModuleReference`s that where implicitly created (e.g., due to another module requesting it as a Dependency and
    /// conforming to ``DefaultInitializable``).
    /// This list is important to keep for the unload mechanism.
    private(set) var implicitlyCreatedModules: Set<ModuleReference> = []

    /// Collection of all modules with dependencies that are not yet processed.
    private var modulesWithDependencies: [any Module]


    /// The current search stack for the module being pushed.
    private var currentPushedModule: ModuleReference?
    private var searchStacks: [ModuleReference: [any Module.Type]] = [:]

    private var nextTypeOrderIndex: UInt64 = 0
    private var moduleTypeOrder: [ObjectIdentifier: UInt64] = [:]


    /// A ``DependencyManager`` in Spezi is used to gather information about modules with dependencies.
    ///
    /// - Parameters:
    ///   - modules: The modules that should be resolved.
    ///   - existingModules: Collection of already initialized modules.
    init(_ modules: [any Module], existing existingModules: [any Module] = []) {
        // modules without dependencies are already considered resolved
        self.initializedModules = modules.filter { $0.dependencyDeclarations.isEmpty }

        self.modulesWithDependencies = modules.filter { !$0.dependencyDeclarations.isEmpty }

        self.originalModules = modules
        self.existingModules = existingModules
    }


    /// Resolves the dependency order.
    ///
    /// After calling `resolve()` you can safely access `initializedModules`.
    func resolve() {
        while let nextModule = modulesWithDependencies.first {
            push(nextModule)
        }

        injectDependencies()
        assert(searchStacks.isEmpty, "`searchStacks` are not getting cleaned up!")
        assert(currentPushedModule == nil, "`currentPushedModule` is never reset!")
        assert(modulesWithDependencies.isEmpty, "modulesWithDependencies has remaining entries \(modulesWithDependencies)")

        buildTypeOrder()

        initializedModules.sort { lhs, rhs in
            retrieveTypeOrder(for: lhs) < retrieveTypeOrder(for: rhs)
        }
    }

    private func buildTypeOrder() {
        // when this method is called, we already know there is no cycle

        func nextEntry(for module: any Module.Type) {
            let id = ObjectIdentifier(module)
            guard moduleTypeOrder[id] == nil else {
                return // already tracked
            }
            moduleTypeOrder[id] = nextTypeOrderIndex
            nextTypeOrderIndex += 1
        }

        func depthFirstSearch(for module: any Module) {
            for declaration in module.dependencyDeclarations {
                for dependency in declaration.unsafeInjectedModules {
                    depthFirstSearch(for: dependency)
                }
            }
            nextEntry(for: type(of: module))
        }

        for module in originalModules {
            depthFirstSearch(for: module)
        }
    }

    private func retrieveTypeOrder(for module: any Module) -> UInt64 {
        guard let order = moduleTypeOrder[ObjectIdentifier(type(of: module))] else {
            preconditionFailure("Failed to retrieve module order index for module of type \(type(of: module))")
        }
        return order
    }

    private func injectDependencies() {
        // We inject dependencies into existingModules as well as a new dependency might be an optional dependency from a existing module
        // that wasn't previously injected.
        for module in initializedModules + existingModules {
            for dependency in module.dependencyDeclarations {
                dependency.inject(from: self, for: module)
            }
        }
    }

    /// Push a module on the search stack and resolve dependency information.
    private func push(_ module: any Module) {
        assert(currentPushedModule == nil, "Module already pushed. Did the algorithm turn into an recursive one by accident?")

        currentPushedModule = ModuleReference(module)
        searchStacks[ModuleReference(module), default: []]
            .append(type(of: module))

        for dependency in module.dependencyDeclarations {
            dependency.collect(into: self) // leads to calls to `require(_:defaultValue:)`
        }

        finishSearch(for: module)
    }

    /// Communicate a requirement to a `DependencyManager`
    /// - Parameters:
    ///   - dependency: The type of the dependency that should be resolved.
    ///   - defaultValue: A default instance of the dependency that is used when the `dependencyType` is not present in the `initializedModules` or `modulesWithDependencies`.
    func require<M: Module>(_ dependency: M.Type, type dependencyType: DependencyType, defaultValue: (() -> M)?) {
        testForSearchStackCycles(M.self)

        // 1. Check if it is actively requested to load this module.
        if case .load = dependencyType {
            guard let defaultValue else {
                return // doesn't make sense, just ignore that
            }

            implicitlyCreate(defaultValue)
            return
        }

        // 2. Return if the depending module is already initialized or being initialized.
        if initializedModules.contains(where: { type(of: $0) == M.self })
            || existingModules.contains(where: { type(of: $0) == M.self })
            || modulesWithDependencies.contains(where: { type(of: $0) == M.self }) {
            return
        }


        // 3. Otherwise, check if there is a default value we can implicitly load
        if let defaultValue {
            implicitlyCreate(defaultValue)
        } else if case .required = dependencyType,
                  let defaultInit = dependency as? DefaultInitializable.Type,
                  let module = defaultInit.init() as? M {
            implicitlyCreate {
                module
            }
        }
    }

    /// Retrieve a resolved dependency for a given type.
    ///
    /// - Parameters:
    ///   - module: The ``Module`` type to return.
    ///   - optional: Flag indicating if it is a optional return.
    /// - Returns: Returns the Module instance. Only optional, if `optional` is set to `true` and no Module was found.
    func retrieve<M: Module>(module: M.Type, type dependencyType: DependencyType, for owner: any Module) -> M? {
        guard let candidate = existingModules.first(where: { type(of: $0) == M.self })
                ?? initializedModules.first(where: { type(of: $0) == M.self }),
              let module = candidate as? M else {
            precondition(
                dependencyType.isOptional,
                """
                '\(type(of: owner)) requires dependency of type '\(M.self)' which wasn't configured.
                Please make sure this module is configured by including it in the configuration of your `SpeziAppDelegate` or following \
                Module-specific instructions.
                """
            )
            return nil
        }

        return module
    }

    private func implicitlyCreate<M: Module>(_ module: () -> M) {
        let newModule = module()

        implicitlyCreatedModules.insert(ModuleReference(newModule))

        if newModule.dependencyDeclarations.isEmpty {
            initializedModules.append(newModule)
        } else {
            saveSearchStack(for: newModule)

            modulesWithDependencies.append(newModule) // appending for BFS
        }
    }

    private func finishSearch(for dependingModule: any Module) {
        currentPushedModule = nil
        searchStacks.removeValue(forKey: ModuleReference(dependingModule))


        let dependingModulesCount = modulesWithDependencies.count
        modulesWithDependencies.removeAll(where: { $0 === dependingModule })
        precondition(dependingModulesCount - 1 == modulesWithDependencies.count, "Unexpected reduction of modules.")

        initializedModules.append(dependingModule)
    }

    private func saveSearchStack<M: Module>(for module: M) {
        guard let currentPushedModule,
              let searchStack = searchStacks[currentPushedModule] else {
            return
        }
        
        // propagate the search stack such that we have it available when we call push for this module
        searchStacks[ModuleReference(module)] = searchStack
    }

    private func testForSearchStackCycles<M>(_ module: M.Type) {
        if let currentPushedModule {
            let searchStack = searchStacks[currentPushedModule, default: []]

            precondition(
                !searchStack.contains(where: { $0 == M.self }),
                """
                The `DependencyManager` has detected a dependency cycle of your Spezi modules.
                The current dependency chain is: \(searchStack.map { String(describing: $0) }.joined(separator: ", ")). \
                The module '\(searchStack.last.unsafelyUnwrapped)' required '\(M.self)' which is contained in its own dependency chain.
                
                Please ensure that the modules you use or develop can not trigger a dependency cycle.
                """
            )
        }
    }
}
