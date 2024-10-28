//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(Spezi) @_spi(APISupport) @testable import Spezi
import SwiftUI
import XCTest
import XCTRuntimeAssertions


private final class TestModule1: Module {
    let deinitExpectation: XCTestExpectation

    @Dependency var testModule2 = TestModule2()
    @Dependency(TestModule3.self) var testModule3

    @Provide var num: Int = 1
    @Provide var nums: [Int] = [9, 10]
    @Provide var numsO: Int? = 11

    init(deinitExpectation: XCTestExpectation = XCTestExpectation()) {
        self.deinitExpectation = deinitExpectation
    }

    deinit {
        deinitExpectation.fulfill()
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

private final class TestModule3: Module, DefaultInitializable, EnvironmentAccessible {
    // EnvironmentAccessible conformance tests that `ModelModifier(model: self)` are removed and no memory leaks occur in Module unloading
    let state: Int
    let deinitExpectation: XCTestExpectation

    @Provide var num: Int = 3

    convenience init() {
        self.init(state: 0)
    }

    init(state: Int, deinitExpectation: XCTestExpectation = .init()) {
        self.state = state
        self.deinitExpectation = deinitExpectation
    }

    deinit {
        deinitExpectation.fulfill()
    }
}

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


func getModule<M: Module>(_ module: M.Type = M.self, in modules: [any Module], file: StaticString = #filePath, line: UInt = #line) throws -> M {
    // swiftlint:disable:previous function_default_parameter_at_end
    try XCTUnwrap(modules.first(where: { $0 is M }) as? M, "Could not find module \(M.self) loaded. Available: \(modules)", file: file, line: line)
}


final class DependencyTests: XCTestCase { // swiftlint:disable:this type_body_length
    @MainActor
    func testLoadingAdditionalDependency() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [OptionalModuleDependency()])

        var modules = spezi.modules
        XCTAssertEqual(modules.count, 2)
        _ = try getModule(DefaultStandard.self, in: modules)
        var optionalModuleDependency: OptionalModuleDependency = try getModule(in: modules)

        XCTAssertNil(optionalModuleDependency.testModule3)

        spezi.loadModule(TestModule3())
        
        modules = spezi.modules
        XCTAssertEqual(modules.count, 3)
        _ = try getModule(DefaultStandard.self, in: modules)
        optionalModuleDependency = try getModule(in: modules)
        var testModule3: TestModule3 = try getModule(in: modules)

        XCTAssert(optionalModuleDependency.testModule3 === testModule3)

        spezi.loadModule(TestModule1())

        modules = spezi.modules
        XCTAssertEqual(modules.count, 7)

        _ = try getModule(DefaultStandard.self, in: modules)
        let testModule1: TestModule1 = try getModule(in: modules)
        let testModule2: TestModule2 = try getModule(in: modules)
        testModule3 = try getModule(in: modules)
        let testModule4: TestModule4 = try getModule(in: modules)
        let testModule5: TestModule5 = try getModule(in: modules)
        optionalModuleDependency = try getModule(in: modules)

        XCTAssert(testModule4.testModule5 === testModule5)
        XCTAssert(testModule2.testModule5 === testModule5)
        XCTAssert(testModule2.testModule4 === testModule4)
        XCTAssert(testModule2.testModule3 === testModule3)
        XCTAssert(testModule1.testModule2 === testModule2)
        XCTAssert(testModule1.testModule3 === testModule3)
        XCTAssert(testModule1.testModule2.testModule3 === testModule3)
        XCTAssert(testModule1.testModule2.testModule4.testModule5 === testModule5)
        XCTAssert(optionalModuleDependency.testModule3 === testModule3)
    }

    @MainActor
    func testImpossibleUnloading() throws {
        let module3 = TestModule3()
        let spezi = Spezi(standard: DefaultStandard(), modules: [TestModule1(), module3])

        // cannot unload module that other modules still depend on
        XCTAssertThrowsError(try spezi._unloadModule(module3)) { error in
            guard let moduleError = error as? SpeziModuleError,
                  case let .moduleStillRequired(module, dependents) = moduleError else {
                XCTFail("Received unexpected error: \(error)")
                return
            }

            XCTAssertEqual(module, "TestModule3")
            XCTAssertEqual(Set(dependents), ["TestModule2", "TestModule1"])
        }
    }

    @MainActor
    func testMultiLoading() throws {
        let module = AllPropertiesModule()
        let spezi = Spezi(standard: DefaultStandard(), modules: [module])

        spezi.unloadModule(module)
        spezi.loadModule(module)
        spezi.unloadModule(module)
    }

    @MainActor
    func testUnloadingDependencies() throws {
        func runUnloadingTests(deinitExpectation1: XCTestExpectation, deinitExpectation3: XCTestExpectation) throws -> Spezi {
            let optionalModule = OptionalModuleDependency()
            let module3 = TestModule3(state: 0, deinitExpectation: deinitExpectation3)
            let module1 = TestModule1(deinitExpectation: deinitExpectation1)

            let spezi = Spezi(standard: DefaultStandard(), modules: [optionalModule])

            // test loading and unloading of @Collect/@Provide property values
            XCTAssertEqual(optionalModule.nums, [])

            spezi.loadModule(module3)
            XCTAssertEqual(optionalModule.nums, [3])

            spezi.loadModule(module1)
            XCTAssertEqual(Set(optionalModule.nums), Set([3, 5, 4, 2, 1, 9, 10, 11]))

            XCTAssertEqual(spezi.modules.count, 7)

            spezi.unloadModule(module1)
            XCTAssertEqual(optionalModule.nums, [3])

            var modules = spezi.modules
            let optionalModuleLoaded: OptionalModuleDependency = try getModule(in: modules)
            let module3Loaded: TestModule3 = try getModule(in: modules)

            XCTAssertNil(modules.first(where: { $0 is TestModule1 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule2 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule4 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule5 }))

            XCTAssert(optionalModuleLoaded.testModule3 === module3Loaded)

            spezi.unloadModule(module3)
            XCTAssertEqual(optionalModule.nums, [])

            modules = spezi.modules

            XCTAssertNil(modules.first(where: { $0 is TestModule1 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule2 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule3 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule4 }))
            XCTAssertNil(modules.first(where: { $0 is TestModule5 }))

            XCTAssertNil(try getModule(OptionalModuleDependency.self, in: modules).testModule3)
            return spezi
        }

        let deinitExpectation1 = XCTestExpectation(description: "Deinit TestModule1")
        let deinitExpectation3 = XCTestExpectation(description: "Deinit TestModule3")

        // make sure we keep the reference to `Spezi`, but loose all references to TestModule3 to test deinit getting called
        let spezi = try runUnloadingTests(deinitExpectation1: deinitExpectation1, deinitExpectation3: deinitExpectation3)
        _ = spezi // silence warning

        wait(for: [deinitExpectation1, deinitExpectation3])
    }

    @MainActor
    func testSelfManagedModules() async throws {
        let optionalModule = OptionalModuleDependency()
        let moduleX = TestModuleX(5)
        let module8 = TestModule8()

        func runModuleTests(deinitExpectation: XCTestExpectation) throws -> Spezi {
            let module1 = TestModule1(deinitExpectation: deinitExpectation)

            let spezi = Spezi(standard: DefaultStandard(), modules: [optionalModule, moduleX, module8])

            spezi.loadModule(module1, ownership: .external) // LOAD AS EXTERNAL
            XCTAssertEqual(Set(optionalModule.nums), Set([5, 5, 4, 3, 2, 1, 9, 10, 11]))

            // leaving this scope causes the module1 to deallocate and should automatically unload it from Spezi!
            XCTAssertEqual(spezi.modules.count, 9)
            return spezi
        }

        let deinitExpectation = XCTestExpectation(description: "Deinit TestModule1")

        // make sure we keep the reference to `Spezi`, but loose all references to TestModule3 to test deinit getting called
        let spezi = try runModuleTests(deinitExpectation: deinitExpectation)
        _ = spezi

        try await Task.sleep(for: .milliseconds(50)) // deinit need to get back to MainActor

        XCTAssertEqual(spezi.modules.count, 5)

        XCTAssertNil(module8.testModule1) // tests that optional @Dependency reference modules weakly
        
        // While TestModule3 was loaded because of TestModule1, the OptionalModule still has a dependency to it.
        // Therefore, they stay loaded.
        XCTAssertNotNil(optionalModule.testModule3)

        XCTAssertEqual(optionalModule.nums, [5, 3])

        wait(for: [deinitExpectation])
    }

    @MainActor
    func testModuleDependencyChain() throws {
        let modules: [any Module] = [
            TestModule6(),
            TestModule1(),
            TestModule7()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)

        XCTAssertEqual(initializedModules.count, 7)
        
        _ = try XCTUnwrap(initializedModules[0] as? TestModule6)
        let testModuleMock5: TestModule5 = try getModule(in: initializedModules)
        let testModuleMock4: TestModule4 = try getModule(in: initializedModules)
        let testModuleMock3: TestModule3 = try getModule(in: initializedModules)
        let testModuleMock2: TestModule2 = try getModule(in: initializedModules)
        let testModuleMock1: TestModule1 = try getModule(in: initializedModules)
        _ = try getModule(TestModule7.self, in: initializedModules)
        
        XCTAssert(testModuleMock4.testModule5 === testModuleMock5)
        XCTAssert(testModuleMock2.testModule5 === testModuleMock5)
        XCTAssert(testModuleMock2.testModule4 === testModuleMock4)
        XCTAssert(testModuleMock2.testModule3 === testModuleMock3)
        XCTAssert(testModuleMock1.testModule2 === testModuleMock2)
        XCTAssert(testModuleMock1.testModule3 === testModuleMock3)
        XCTAssert(testModuleMock1.testModule2.testModule3 === testModuleMock3)
        XCTAssert(testModuleMock1.testModule2.testModule4.testModule5 === testModuleMock5)
    }

    @MainActor
    func testAlreadyInDependableModules() throws {
        let modules: [any Module] = [
            TestModule2(),
            TestModule5()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)

        XCTAssertEqual(initializedModules.count, 4)
        
        let testModule5: TestModule5 = try getModule(in: initializedModules)
        let testModule4: TestModule4 = try getModule(in: initializedModules)
        let testModule3: TestModule3 = try getModule(in: initializedModules)
        let testModule2: TestModule2 = try getModule(in: initializedModules)

        XCTAssert(testModule4.testModule5 === testModule5)
        XCTAssert(testModule2.testModule5 === testModule5)
        XCTAssert(testModule2.testModule4 === testModule4)
        XCTAssert(testModule2.testModule3 === testModule3)
    }

    @MainActor
    func testModuleDependencyMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule5(),
            TestModule4(),
            TestModule4()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)

        XCTAssertEqual(initializedModules.count, 3)

        let testModule5: TestModule5 = try getModule(in: initializedModules)
        let testModule40 = try XCTUnwrap(initializedModules.compactMap { $0 as? TestModule4 }.first)
        let testModule41 = try XCTUnwrap(initializedModules.compactMap { $0 as? TestModule4 }.last)

        XCTAssert(testModule40 !== testModule41)
        
        XCTAssert(testModule40.testModule5 === testModule5)
        XCTAssert(testModule41.testModule5 === testModule5)
    }

    @MainActor
    func testModuleDependencyChainMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule2(),
            TestModule2()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)

        XCTAssertEqual(initializedModules.count, 5)

        let testModule5: TestModule5 = try getModule(in: initializedModules)
        let testModule4: TestModule4 = try getModule(in: initializedModules)
        let testModule3: TestModule3 = try getModule(in: initializedModules)
        let testModule20 = try XCTUnwrap(initializedModules.compactMap { $0 as? TestModule2 }.first)
        let testModule21 = try XCTUnwrap(initializedModules.compactMap { $0 as? TestModule2 }.last)

        XCTAssert(testModule4.testModule5 === testModule5)
        
        XCTAssert(testModule20 !== testModule21)
        
        XCTAssert(testModule20.testModule3 === testModule3)
        XCTAssert(testModule21.testModule3 === testModule3)
        XCTAssert(testModule20.testModule4 === testModule4)
        XCTAssert(testModule21.testModule4 === testModule4)
        XCTAssert(testModule20.testModule5 === testModule5)
        XCTAssert(testModule21.testModule5 === testModule5)
        
        XCTAssert(testModule20.testModule4.testModule5 === testModule5)
        XCTAssert(testModule21.testModule4.testModule5 === testModule5)
    }


    @MainActor
    func testModuleNoDependency() throws {
        let modules: [any Module] = [TestModule5()]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)

        XCTAssertEqual(initializedModules.count, 1)

        _ = try XCTUnwrap(initializedModules[0] as? TestModule5)
    }

    @MainActor
    func testModuleNoDependencyMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule5(),
            TestModule5(),
            TestModule5()
        ]
        let initializedModules = DependencyManager.resolveWithoutErrors(modules)

        XCTAssertEqual(initializedModules.count, 3)

        _ = try XCTUnwrap(initializedModules[0] as? TestModule5)
        _ = try XCTUnwrap(initializedModules[1] as? TestModule5)
        _ = try XCTUnwrap(initializedModules[2] as? TestModule5)
    }

    @MainActor
    func testOptionalDependenceNonPresent() throws {
        let nonPresent: [any Module] = [
            OptionalModuleDependency()
        ]

        let modules = DependencyManager.resolveWithoutErrors(nonPresent)

        XCTAssertEqual(modules.count, 1)

        let module = try XCTUnwrap(modules[0] as? OptionalModuleDependency)
        XCTAssertNil(module.testModule3)
    }

    @MainActor
    func testOptionalDependencePresent() throws {
        let nonPresent: [any Module] = [
            OptionalModuleDependency(),
            TestModule3()
        ]

        let modules = DependencyManager.resolveWithoutErrors(nonPresent)

        XCTAssertEqual(modules.count, 2)

        let module3 = try XCTUnwrap(modules[0] as? TestModule3)
        let module = try XCTUnwrap(modules[1] as? OptionalModuleDependency)
        XCTAssert(module.testModule3 === module3)
    }

    @MainActor
    func testOptionalDependencyWithDynamicRuntimeDefaultValue() throws {
        let nonPresent = DependencyManager.resolveWithoutErrors([
            OptionalDependencyWithRuntimeDefault(defaultValue: nil) // stays optional
        ])

        let dut1 = try XCTUnwrap(nonPresent[0] as? OptionalDependencyWithRuntimeDefault)
        XCTAssertNil(dut1.testModule3)

        let configured = DependencyManager.resolveWithoutErrors([
            TestModule3(state: 1),
            OptionalDependencyWithRuntimeDefault(defaultValue: nil)
        ])

        let dut2 = try XCTUnwrap(configured[1] as? OptionalDependencyWithRuntimeDefault)
        let dut2Module = try XCTUnwrap(dut2.testModule3)
        XCTAssertEqual(dut2Module.state, 1)

        let defaulted = DependencyManager.resolveWithoutErrors([
            OptionalDependencyWithRuntimeDefault(defaultValue: 2)
        ])

        let dut3 = try XCTUnwrap(defaulted[1] as? OptionalDependencyWithRuntimeDefault)
        let dut3Module = try XCTUnwrap(dut3.testModule3)
        XCTAssertEqual(dut3Module.state, 2)

        let configuredAndDefaulted = DependencyManager.resolveWithoutErrors([
            TestModule3(state: 4),
            OptionalDependencyWithRuntimeDefault(defaultValue: 3)
        ])

        let dut4 = try XCTUnwrap(configuredAndDefaulted[1] as? OptionalDependencyWithRuntimeDefault)
        let dut4Module = try XCTUnwrap(dut4.testModule3)
        XCTAssertEqual(dut4Module.state, 4)
    }

    @MainActor
    func testMultipleDependenciesOfSameType() throws {
        let first = TestModule5()
        let second = TestModule5()

        let spezi = Spezi(standard: DefaultStandard(), modules: [first, second, TestModule4()])

        let modules = spezi.modules

        XCTAssertEqual(modules.count, 4) // 3 modules + standard
        _ = try getModule(DefaultStandard.self, in: modules)

        let testModule4 = try getModule(TestModule4.self, in: modules)

        XCTAssertTrue(testModule4.testModule5 === first)
    }

    @MainActor
    func testUnloadingWeakDependencyOfSameType() async throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [SimpleOptionalModuleDependency()])

        let modules = spezi.modules

        XCTAssertEqual(modules.count, 2)
        _ = try getModule(DefaultStandard.self, in: modules)
        let module = try getModule(SimpleOptionalModuleDependency.self, in: modules)

        XCTAssertNil(module.testModule6)

        let dynamicModule6 = TestModule6()
        let baseModule6 = TestModule6()

        let scope = {
            let weakModule6 = TestModule6()

            spezi.loadModule(weakModule6, ownership: .external)
            spezi.loadModule(dynamicModule6)
            spezi.loadModule(baseModule6)

            // should contain the first loaded dependency
            XCTAssertNotNil(module.testModule6)
            XCTAssertTrue(module.testModule6 === weakModule6)
        }

        scope()

        // after externally managed dependency goes out of scope it should automatically switch to next dependency
        XCTAssertNotNil(module.testModule6)
        XCTAssertTrue(module.testModule6 === dynamicModule6)

        spezi.unloadModule(dynamicModule6)

        // after manual unload it should take the next available
        XCTAssertNotNil(module.testModule6)
        XCTAssertTrue(module.testModule6 === baseModule6)
    }

    @MainActor
    func testModuleLoadingOrderAndRequiredModulesBehavior() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [ModuleWithRequiredDependency()])

        let modules = spezi.modules

        let module: ModuleWithRequiredDependency = try getModule(in: modules)

        // This tests that dependencies declared on the "outside" take precedence. We test that we are doing a BFS.
        XCTAssertEqual(module.testModuleX.numX, 42)

        // ensures that we are able to retrieve the required module (that the inner default value was injected)
        _ = try getModule(TestModule6.self, in: modules)
        _ = module.testModule6
    }

    @MainActor
    func testInjectionOfOptionalDependencyWithDefaultValue() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [InjectionOfOptionalDefaultValue()])

        let modules = spezi.modules

        let module: InjectionOfOptionalDefaultValue = try getModule(in: modules)

        let testX = try XCTUnwrap(module.testModuleX)
        XCTAssertEqual(testX.numX, 23)
    }

    @MainActor
    func testModuleCircle1() throws {
        let module2 = TestModuleCircle2()
        let module1 = TestModuleCircle1(module: module2)

        XCTAssertThrowsError(try DependencyManager.resolve([module1])) { error in
            guard let dependencyError = error as? DependencyManagerError,
                  case let .searchStackCycle(module, requestedModule, dependencyChain) = dependencyError else {
                XCTFail("Received unexpected error: \(error)")
                return
            }

            XCTAssertEqual(module, "TestModuleCircle2")
            XCTAssertEqual(requestedModule, "TestModuleCircle1")
            XCTAssertEqual(dependencyChain, ["TestModuleCircle1", "TestModuleCircle2"])
        }
    }

    @MainActor
    func testMissingRequiredModule() throws {
        class Module1: Module {
            @Dependency(TestModuleX.self) var module
        }

        XCTAssertThrowsError(try DependencyManager.resolve([Module1()])) { error in
            guard let dependencyError = error as? DependencyManagerError,
                  case let .missingRequiredModule(module, requiredModule) = dependencyError else {
                XCTFail("Received unexpected error: \(error)")
                return
            }

            print(error)
            XCTAssertEqual(module, "Module1")
            XCTAssertEqual(requiredModule, "TestModuleX")
        }
    }

    @MainActor
    func testConfigureCallOrder() throws {
        class Order: Module, DefaultInitializable {
            @MainActor
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

        XCTAssertEqual(order.order, [1, 2, 3, 4, 4])
    }

    @available(*, deprecated, message: "Propagate deprecation warning")
    @MainActor
    func testDeprecatedInits() throws {
        let spezi = Spezi(standard: DefaultStandard(), modules: [DeprecatedDeclarations()])

        let modules = spezi.modules

        let module: DeprecatedDeclarations = try getModule(in: modules)

        XCTAssertNil(module.testModule6)
        XCTAssertEqual(module.testModule3.state, 0)
        XCTAssertEqual(module.testModule3.num, 3)
    }
}

// swiftlint:disable:this file_length
