//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) @testable import Spezi
#if canImport(SwiftUI)
import SwiftUI
#endif
import Testing

private final class TestModule1: Module {
    let deinitExpectation: TestExpectation?
    
    @Dependency var testModule2 = TestModule2()
    @Dependency(TestModule3.self) var testModule3
    
    @Provide var num: Int = 1
    @Provide var nums: [Int] = [9, 10]
    @Provide var numsO: Int? = 11
    
    init(deinitExpectation: TestExpectation? = nil) {
        self.deinitExpectation = deinitExpectation
    }
    
    deinit {
        deinitExpectation?.fulfill()
    }
}

private final class TestModuleX: Module {
    @Provide var numX: Int
    
    init(_ num: Int) {
        numX = num
    }
}

private final class TestModule2: Module {
    @Dependency var testModule4 = TestModule4()
    @Dependency var testModule5 = TestModule5()
    @Dependency(TestModule3.self) var testModule3
    
    @Provide var num: Int = 2
}

private class TestModule3: Module, DefaultInitializable {
    // EnvironmentAccessible conformance tests that `ModelModifier(model: self)` are removed and no memory leaks occur in Module unloading
    let state: Int
    let deinitExpectation: TestExpectation?
    
    @Provide var num: Int = 3
    
    required convenience init() {
        self.init(state: 0)
    }
    
    init(state: Int, deinitExpectation: TestExpectation? = nil) {
        self.state = state
        self.deinitExpectation = deinitExpectation
    }
    
    deinit {
        deinitExpectation?.fulfill()
    }
}

#if canImport(SwiftUI)
extension TestModule3: EnvironmentAccessible {}
#endif

private final class TestModule4: Module {
    @Dependency var testModule5 = TestModule5()
    
    @Provide var num: Int = 4
}

private final class TestModule5: Module {
    @Provide var num: Int = 5
}

private final class TestModule6: Module {}

private final class TestModule7: Module {
    @Dependency var testModule1 = TestModule1()
}


private final class OptionalModuleDependency: Module {
    @Dependency(TestModule3.self) var testModule3: TestModule3?
    
    @Collect var nums: [Int]
}

#if canImport(SwiftUI)
private final class AllPropertiesModule: Module {
    @Observable
    class MyModel {}
    struct MyViewModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
        }
    }
    
    @Dependency(TestModule3.self) var testModule3
    @Application(\.logger) var logger
    @Application(\.spezi) var spezi
    @Collect var nums: [Int]
    @Provide var num: Int = 3
    @Model var model = MyModel()
    @Modifier var modifier = MyViewModifier()
    @StandardActor var defaultStandard: any Standard
}
#endif

private final class OptionalDependencyWithRuntimeDefault: Module {
    @Dependency(TestModule3.self) var testModule3: TestModule3?
    
    init(defaultValue: Int?) {
        if let defaultValue {
            _testModule3 = Dependency(wrappedValue: TestModule3(state: defaultValue))
        }
    }
}

private final class TestModule8: Module {
    @Dependency(TestModule1.self) var testModule1: TestModule1?
    
    init() {}
}

private final class SimpleOptionalModuleDependency: Module {
    @Dependency(TestModule6.self) var testModule6: TestModule6?
}


private final class ModuleWithRequiredDependency: Module {
    final class NestedX: Module, DefaultInitializable {
        @Dependency var testModuleX = TestModuleX(12)
        
        @Dependency var testModule6 = TestModule6()
        
        init() {}
    }
    
    @Dependency(TestModule6.self) var testModule6 // either specified from the outside, or it takes the default value from the NestedX
    
    @Dependency(NestedX.self) var nestedX
    @Dependency(TestModuleX.self) var testModuleX: TestModuleX // see in init!
    
    
    init() {
        // test that we are searching breadth first
        _testModuleX = Dependency(load: TestModuleX(42))
    }
}


private final class InjectionOfOptionalDefaultValue: Module {
    final class NestedX: Module {
        @Dependency var testModuleX = TestModuleX(23)
    }
    @Dependency(TestModuleX.self) var testModuleX: TestModuleX? // make sure optional dependencies get injected with the default value!
    @Dependency var nested = NestedX()
    
    init() {}
}

private final class TestModuleCircle1: Module {
    @Dependency var modules: [any Module]
    
    init() {}
    
    init<M: Module>(module: M) {
        self._modules = Dependency {
            module
        }
    }
}

private final class TestModuleCircle2: Module {
    @Dependency var module = TestModuleCircle1()
}


// Test that deprecated declaration still compile as expected
@available(*, deprecated, message: "Propagate deprecation warning")
private final class DeprecatedDeclarations: Module {
    @Dependency var testModule3: TestModule3
    @Dependency var testModule6: TestModule6?
}


func getModule<M: Module>(_ module: M.Type = M.self, in modules: [any Module]) throws -> M {
    // swiftlint:disable:previous function_default_parameter_at_end
    try #require(modules.first(where: { $0 is M }) as? M, "Could not find module \(M.self) loaded. Available: \(modules)")
}

@MainActor
@Suite("Dependency Tests")
struct DependencyTests { // swiftlint:disable:this type_body_length
    @Test
    func loadingAdditionalDependency() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [OptionalModuleDependency()])
        
        var modules = spezi.modules
        #expect(modules.count == 2)
        _ = try getModule(DefaultStandard.self, in: modules)
        var optionalModuleDependency: OptionalModuleDependency = try getModule(in: modules)
        
        #expect(optionalModuleDependency.testModule3 == nil)
        
        spezi.loadModule(TestModule3())
        
        modules = spezi.modules
        #expect(modules.count == 3)
        _ = try getModule(DefaultStandard.self, in: modules)
        optionalModuleDependency = try getModule(in: modules)
        var testModule3: TestModule3 = try getModule(in: modules)
        
        #expect(optionalModuleDependency.testModule3 === testModule3)
        
        spezi.loadModule(TestModule1())
        
        modules = spezi.modules
        #expect(modules.count == 7)
        
        _ = try getModule(DefaultStandard.self, in: modules)
        let testModule1: TestModule1 = try getModule(in: modules)
        let testModule2: TestModule2 = try getModule(in: modules)
        testModule3 = try getModule(in: modules)
        let testModule4: TestModule4 = try getModule(in: modules)
        let testModule5: TestModule5 = try getModule(in: modules)
        optionalModuleDependency = try getModule(in: modules)
        
        #expect(testModule4.testModule5 === testModule5)
        #expect(testModule2.testModule5 === testModule5)
        #expect(testModule2.testModule4 === testModule4)
        #expect(testModule2.testModule3 === testModule3)
        #expect(testModule1.testModule2 === testModule2)
        #expect(testModule1.testModule3 === testModule3)
        #expect(testModule1.testModule2.testModule3 === testModule3)
        #expect(testModule1.testModule2.testModule4.testModule5 === testModule5)
        #expect(optionalModuleDependency.testModule3 === testModule3)
    }
    
    @Test
    func impossibleUnloading() throws {
        let module3 = TestModule3()
        let spezi = Spezi(standard: DefaultStandard(), modules: [TestModule1(), module3])
        
        // cannot unload module that other modules still depend on
        let moduleError = try #require(throws: SpeziModuleError.self) {
            try spezi._unloadModule(module3)
        }
        
        guard case let .moduleStillRequired(module, dependents) = moduleError else {
            Issue.record("Received unexpected error: \(moduleError)")
            return
        }
        
        #expect(module == "TestModule3")
        #expect(Set(dependents) == ["TestModule2", "TestModule1"])
    }
    
#if canImport(SwiftUI)
    @Test
    func multiLoading() throws {
        let module = AllPropertiesModule()
        let spezi = Spezi(standard: DefaultStandard(), modules: [module])
        
        spezi.unloadModule(module)
        spezi.loadModule(module)
        spezi.unloadModule(module)
    }
#endif
    
    @Test
    func unloadingDependencies() async throws {
        func runUnloadingTests(deinitExpectation1: TestExpectation, deinitExpectation3: TestExpectation) throws -> Spezi {
            let optionalModule = OptionalModuleDependency()
            let module3 = TestModule3(state: 0, deinitExpectation: deinitExpectation3)
            let module1 = TestModule1(deinitExpectation: deinitExpectation1)
            
            let spezi = Spezi(standard: DefaultStandard(), modules: [optionalModule])
            
            // test loading and unloading of @Collect/@Provide property values
            #expect(optionalModule.nums.isEmpty)
            
            spezi.loadModule(module3)
            #expect(optionalModule.nums == [3])
            
            spezi.loadModule(module1)
            #expect(Set(optionalModule.nums) == Set([3, 5, 4, 2, 1, 9, 10, 11]))
            
            #expect(spezi.modules.count == 7)
            
            spezi.unloadModule(module1)
            #expect(optionalModule.nums == [3])
            
            var modules = spezi.modules
            let optionalModuleLoaded: OptionalModuleDependency = try getModule(in: modules)
            let module3Loaded: TestModule3 = try getModule(in: modules)
            
            #expect(!modules.contains { $0 is TestModule1 })
            #expect(!modules.contains { $0 is TestModule2 })
            #expect(!modules.contains { $0 is TestModule4 })
            #expect(!modules.contains { $0 is TestModule5 })
            
            #expect(optionalModuleLoaded.testModule3 === module3Loaded)
            
            spezi.unloadModule(module3)
            #expect(optionalModule.nums.isEmpty)
            
            modules = spezi.modules
            
            #expect(!modules.contains { $0 is TestModule1 })
            #expect(!modules.contains { $0 is TestModule2 })
            #expect(!modules.contains { $0 is TestModule3 })
            #expect(!modules.contains { $0 is TestModule4 })
            #expect(!modules.contains { $0 is TestModule5 })
            
            #expect(try getModule(OptionalModuleDependency.self, in: modules).testModule3 == nil)
            return spezi
        }
        
        let deinitExpectation1 = TestExpectation()
        let deinitExpectation3 = TestExpectation()
        
        // make sure we keep the reference to `Spezi`, but loose all references to TestModule3 to test deinit getting called
        let spezi = try runUnloadingTests(deinitExpectation1: deinitExpectation1, deinitExpectation3: deinitExpectation3)
        _ = spezi // silence warning
        
        await TestExpectations(deinitExpectation1, deinitExpectation3).fulfillment(within: .seconds(5))
    }
    
    
    @Test
    func selfManagedModules() async throws {
        let optionalModule = OptionalModuleDependency()
        let moduleX = TestModuleX(5)
        let module8 = TestModule8()
        
        func runModuleTests(deinitExpectation: TestExpectation) throws -> Spezi {
            let module1 = TestModule1(deinitExpectation: deinitExpectation)
            
            let spezi = Spezi(standard: DefaultStandard(), modules: [optionalModule, moduleX, module8])
            
            spezi.loadModule(module1, ownership: .external) // LOAD AS EXTERNAL
            #expect(Set(optionalModule.nums) == Set([5, 5, 4, 3, 2, 1, 9, 10, 11]))
            
            // leaving this scope causes the module1 to deallocate and should automatically unload it from Spezi!
            #expect(spezi.modules.count == 9)
            return spezi
        }
        
        let deinitExpectation = TestExpectation()
        
        // make sure we keep the reference to `Spezi`, but loose all references to TestModule3 to test deinit getting called
        let spezi = try runModuleTests(deinitExpectation: deinitExpectation)
        _ = spezi
        
        try await Task.sleep(for: .milliseconds(250)) // deinit need to get back to MainActor
        
        #expect(spezi.modules.count == 5)
        
        #expect(module8.testModule1 == nil) // tests that optional @Dependency reference modules weakl == nily
        
        // While TestModule3 was loaded because of TestModule1, the OptionalModule still has a dependency to it.
        // Therefore, they stay loaded.
        #expect(optionalModule.testModule3 != nil)
        
        #expect(optionalModule.nums == [5, 3])
        
        await deinitExpectation.fulfillment(within: .seconds(10))
    }
    
    @Test
    func moduleDependencyChain() throws {
        let modules: [any Module] = [
            TestModule6(),
            TestModule1(),
            TestModule7()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)
        
        #expect(initializedModules.count == 7)
        
        _ = try #require(initializedModules[0] as? TestModule6)
        let testModuleMock5: TestModule5 = try getModule(in: initializedModules)
        let testModuleMock4: TestModule4 = try getModule(in: initializedModules)
        let testModuleMock3: TestModule3 = try getModule(in: initializedModules)
        let testModuleMock2: TestModule2 = try getModule(in: initializedModules)
        let testModuleMock1: TestModule1 = try getModule(in: initializedModules)
        _ = try getModule(TestModule7.self, in: initializedModules)
        
        #expect(testModuleMock4.testModule5 === testModuleMock5)
        #expect(testModuleMock2.testModule5 === testModuleMock5)
        #expect(testModuleMock2.testModule4 === testModuleMock4)
        #expect(testModuleMock2.testModule3 === testModuleMock3)
        #expect(testModuleMock1.testModule2 === testModuleMock2)
        #expect(testModuleMock1.testModule3 === testModuleMock3)
        #expect(testModuleMock1.testModule2.testModule3 === testModuleMock3)
        #expect(testModuleMock1.testModule2.testModule4.testModule5 === testModuleMock5)
    }
    
    @Test
    func alreadyInDependableModules() throws {
        let modules: [any Module] = [
            TestModule2(),
            TestModule5()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)
        
        #expect(initializedModules.count == 4)
        
        let testModule5: TestModule5 = try getModule(in: initializedModules)
        let testModule4: TestModule4 = try getModule(in: initializedModules)
        let testModule3: TestModule3 = try getModule(in: initializedModules)
        let testModule2: TestModule2 = try getModule(in: initializedModules)
        
        #expect(testModule4.testModule5 === testModule5)
        #expect(testModule2.testModule5 === testModule5)
        #expect(testModule2.testModule4 === testModule4)
        #expect(testModule2.testModule3 === testModule3)
    }
    
    @Test
    func moduleDependencyMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule5(),
            TestModule4(),
            TestModule4()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)
        
        #expect(initializedModules.count == 3)
        
        let testModule5: TestModule5 = try getModule(in: initializedModules)
        let testModule40 = try #require(initializedModules.compactMap { $0 as? TestModule4 }.first)
        let testModule41 = try #require(initializedModules.compactMap { $0 as? TestModule4 }.last)
        
        #expect(testModule40 !== testModule41)
        
        #expect(testModule40.testModule5 === testModule5)
        #expect(testModule41.testModule5 === testModule5)
    }
    
    @Test
    func moduleDependencyChainMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule2(),
            TestModule2()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)
        
        #expect(initializedModules.count == 5)
        
        let testModule5: TestModule5 = try getModule(in: initializedModules)
        let testModule4: TestModule4 = try getModule(in: initializedModules)
        let testModule3: TestModule3 = try getModule(in: initializedModules)
        let testModule20 = try #require(initializedModules.compactMap { $0 as? TestModule2 }.first)
        let testModule21 = try #require(initializedModules.compactMap { $0 as? TestModule2 }.last)
        
        #expect(testModule4.testModule5 === testModule5)
        
        #expect(testModule20 !== testModule21)
        
        #expect(testModule20.testModule3 === testModule3)
        #expect(testModule21.testModule3 === testModule3)
        #expect(testModule20.testModule4 === testModule4)
        #expect(testModule21.testModule4 === testModule4)
        #expect(testModule20.testModule5 === testModule5)
        #expect(testModule21.testModule5 === testModule5)
        
        #expect(testModule20.testModule4.testModule5 === testModule5)
        #expect(testModule21.testModule4.testModule5 === testModule5)
    }
    
    @Test
    func moduleNoDependency() throws {
        let modules: [any Module] = [TestModule5()]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)
        
        #expect(initializedModules.count == 1)
        
        _ = try #require(initializedModules[0] as? TestModule5)
    }
    
    @Test
    func moduleNoDependencyMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule5(),
            TestModule5(),
            TestModule5()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)
        
        #expect(initializedModules.count == 3)
        
        _ = try #require(initializedModules[0] as? TestModule5)
        _ = try #require(initializedModules[1] as? TestModule5)
        _ = try #require(initializedModules[2] as? TestModule5)
    }
    
    @Test
    func optionalDependenceNonPresent() throws {
        let nonPresent: [any Module] = [
            OptionalModuleDependency()
        ]
        
        let modules = DependencyManager.resolveWithoutErrors(nonPresent)
        
        #expect(modules.count == 1)
        
        let module = try #require(modules[0] as? OptionalModuleDependency)
        #expect(module.testModule3 == nil)
    }
    
    @Test
    func optionalDependencePresent() throws {
        let nonPresent: [any Module] = [
            OptionalModuleDependency(),
            TestModule3()
        ]
        
        let modules = DependencyManager.resolveWithoutErrors(nonPresent)
        
        #expect(modules.count == 2)
        
        let module3 = try #require(modules[0] as? TestModule3)
        let module = try #require(modules[1] as? OptionalModuleDependency)
        #expect(module.testModule3 === module3)
    }
    
    @Test
    func optionalDependencyWithDynamicRuntimeDefaultValue() throws {
        let nonPresent = DependencyManager.resolveWithoutErrors([
            OptionalDependencyWithRuntimeDefault(defaultValue: nil) // stays optional
        ])
        
        let dut1 = try #require(nonPresent[0] as? OptionalDependencyWithRuntimeDefault)
        #expect(dut1.testModule3 == nil)
        
        let configured = DependencyManager.resolveWithoutErrors([
            TestModule3(state: 1),
            OptionalDependencyWithRuntimeDefault(defaultValue: nil)
        ])
        
        let dut2 = try #require(configured[1] as? OptionalDependencyWithRuntimeDefault)
        let dut2Module = try #require(dut2.testModule3)
        #expect(dut2Module.state == 1)
        
        let defaulted = DependencyManager.resolveWithoutErrors([
            OptionalDependencyWithRuntimeDefault(defaultValue: 2)
        ])
        
        let dut3 = try #require(defaulted[1] as? OptionalDependencyWithRuntimeDefault)
        let dut3Module = try #require(dut3.testModule3)
        #expect(dut3Module.state == 2)
        
        let configuredAndDefaulted = DependencyManager.resolveWithoutErrors([
            TestModule3(state: 4),
            OptionalDependencyWithRuntimeDefault(defaultValue: 3)
        ])
        
        let dut4 = try #require(configuredAndDefaulted[1] as? OptionalDependencyWithRuntimeDefault)
        let dut4Module = try #require(dut4.testModule3)
        #expect(dut4Module.state == 4)
    }
    
    @Test
    func multipleDependenciesOfSameType() throws {
        let first = TestModule5()
        let second = TestModule5()
        
        let spezi = Spezi(standard: DefaultStandard(), modules: [first, second, TestModule4()])
        
        let modules = spezi.modules
        
        #expect(modules.count == 4) // 3 modules + standard
        _ = try getModule(DefaultStandard.self, in: modules)
        
        let testModule4 = try getModule(TestModule4.self, in: modules)
        
        #expect(testModule4.testModule5 === first)
    }
    
    @Test
    func unloadingWeakDependencyOfSameType() async throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [SimpleOptionalModuleDependency()])
        
        let modules = spezi.modules
        
        #expect(modules.count == 2)
        _ = try getModule(DefaultStandard.self, in: modules)
        let module = try getModule(SimpleOptionalModuleDependency.self, in: modules)
        
        #expect(module.testModule6 == nil)
        
        let dynamicModule6 = TestModule6()
        let baseModule6 = TestModule6()
        
        let scope = {
            let weakModule6 = TestModule6()
            
            spezi.loadModule(weakModule6, ownership: .external)
            spezi.loadModule(dynamicModule6)
            spezi.loadModule(baseModule6)
            
            // should contain the first loaded dependency
            #expect(module.testModule6 != nil)
            #expect(module.testModule6 === weakModule6)
        }
        
        scope()
        
        // after externally managed dependency goes out of scope it should automatically switch to next dependency
        #expect(module.testModule6 != nil)
        #expect(module.testModule6 === dynamicModule6)
        
        spezi.unloadModule(dynamicModule6)
        
        // after manual unload it should take the next available
        #expect(module.testModule6 != nil)
        #expect(module.testModule6 === baseModule6)
    }
    
    @Test
    func moduleLoadingOrderAndRequiredModulesBehavior() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [ModuleWithRequiredDependency()])
        
        let modules = spezi.modules
        
        let module: ModuleWithRequiredDependency = try getModule(in: modules)
        
        // This tests that dependencies declared on the "outside" take precedence. We test that we are doing a BFS.
        #expect(module.testModuleX.numX == 42)
        
        // ensures that we are able to retrieve the required module (that the inner default value was injected)
        _ = try getModule(TestModule6.self, in: modules)
        _ = module.testModule6
    }
    
    @Test
    func injectionOfOptionalDependencyWithDefaultValue() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [InjectionOfOptionalDefaultValue()])
        
        let modules = spezi.modules
        
        let module: InjectionOfOptionalDefaultValue = try getModule(in: modules)
        
        let testX = try #require(module.testModuleX)
        #expect(testX.numX == 23)
    }
    
    @Test
    func moduleCircle1() throws {
        let module2 = TestModuleCircle2()
        let module1 = TestModuleCircle1(module: module2)
        
        let error = try #require(throws: DependencyManagerError.self) {
            try DependencyManager.resolve([module1])
        }
        
        guard case let .searchStackCycle(module, requestedModule, dependencyChain) = error else {
            Issue.record("Received unexpected error: \(error)")
            return
        }
        
        #expect(module == "TestModuleCircle2")
        #expect(requestedModule == "TestModuleCircle1")
        #expect(dependencyChain == ["TestModuleCircle1", "TestModuleCircle2"])
    }
    
    @Test
    func missingRequiredModule() throws {
        class Module1: Module {
            @Dependency(TestModuleX.self) var module
        }
        
        let error = try #require(throws: DependencyManagerError.self) {
            try DependencyManager.resolve([Module1()])
        }
        
        guard case let .missingRequiredModule(module, requiredModule) = error else {
            Issue.record("Received unexpected error: \(error)")
            return
        }
        
        #expect(module == "Module1")
        #expect(requiredModule == "TestModuleX")
    }
    
    @Test
    func configureCallOrder() throws {
        class Order: Module, DefaultInitializable {
            var order: [Int] = []
            
            required init() {}
        }
        
        class ModuleA: Module {
            @Dependency(Order.self)
            private var order
            
            func configure() {
                order.order.append(1)
            }
        }
        
        class ModuleB: Module {
            @Dependency(Order.self)
            private var order
            
            @Dependency(ModuleA.self)
            private var module = ModuleA()
            
            func configure() {
                order.order.append(2)
            }
        }
        
        class ModuleC: Module {
            @Dependency(Order.self)
            private var order
            
            @Dependency(ModuleA.self)
            private var moduleA
            @Dependency(ModuleB.self)
            private var moduleB
            
            func configure() {
                order.order.append(3)
            }
        }
        
        class ModuleD: Module {
            @Dependency(Order.self)
            private var order
            
            @Dependency(ModuleC.self)
            private var module
            
            func configure() {
                order.order.append(4)
            }
        }
        
        let spezi = Spezi(standard: DefaultStandard(), modules: [
            ModuleC(),
            ModuleB(),
            ModuleD(),
            ModuleD()
        ])
        
        let modules = spezi.modules
        let order: Order = try getModule(in: modules)
        
        #expect(order.order == [1, 2, 3, 4, 4])
    }
    
    
    @available(*, deprecated, message: "Propagate deprecation warning")
    @Test
    func deprecatedInits() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [DeprecatedDeclarations()])
        
        let modules = spezi.modules
        
        let module: DeprecatedDeclarations = try getModule(in: modules)
        
        #expect(module.testModule6 == nil)
        #expect(module.testModule3.state == 0)
        #expect(module.testModule3.num == 3)
    }
}

// swiftlint:disable:this file_length
