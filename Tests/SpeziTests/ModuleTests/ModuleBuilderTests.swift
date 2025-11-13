//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import Testing

@MainActor
@Suite(.serialized)
struct ModuleBuilderTests {
    private struct ModuleBuilderExpectations {
        let firstTestExpectation: TestExpectation
        let nestedTestModuleOne: TestExpectation
        let nestedTestModuleTwo: TestExpectation
        let loopTestExpectation: TestExpectation
        let conditionalTestExpectation: TestExpectation
        let availableConditionalTestExpectation: TestExpectation
        let ifTestExpectation: TestExpectation
        let elseTestExpectation: TestExpectation
        
        init(
            firstTestExpectation: TestExpectation = TestExpectation(),
            nestedTestModuleOne: TestExpectation = TestExpectation(),
            nestedTestModuleTwo: TestExpectation = TestExpectation(),
            loopTestExpectation: TestExpectation = TestExpectation(),
            conditionalTestExpectation: TestExpectation = TestExpectation(),
            availableConditionalTestExpectation: TestExpectation = TestExpectation(),
            ifTestExpectation: TestExpectation = TestExpectation(),
            elseTestExpectation: TestExpectation = TestExpectation(),
        ) {
            self.firstTestExpectation = firstTestExpectation
            self.nestedTestModuleOne = nestedTestModuleOne
            self.nestedTestModuleTwo = nestedTestModuleTwo
            self.loopTestExpectation = loopTestExpectation
            self.conditionalTestExpectation = conditionalTestExpectation
            self.availableConditionalTestExpectation = availableConditionalTestExpectation
            self.ifTestExpectation = ifTestExpectation
            self.elseTestExpectation = elseTestExpectation
        }
        
        func fulfillment() async {
            await TestExpectations(
                firstTestExpectation,
                nestedTestModuleOne,
                nestedTestModuleTwo,
                loopTestExpectation,
                conditionalTestExpectation,
                availableConditionalTestExpectation,
                ifTestExpectation,
                elseTestExpectation
            )
            .fulfillment(within: .seconds(5))
        }
    }
    
    
    private func modules(loopLimit: Int, condition: Bool, moduleBuilderExpectations: ModuleBuilderExpectations) -> ModuleCollection {
        @ModuleBuilder
        var nestedModules: ModuleCollection {
            TestModule(expectation: moduleBuilderExpectations.nestedTestModuleOne)
            TestModule(expectation: moduleBuilderExpectations.nestedTestModuleTwo)
        }
        
        @ModuleBuilder
        var modules: ModuleCollection {
            TestModule(expectation: moduleBuilderExpectations.firstTestExpectation)
            nestedModules
            for _ in 0..<loopLimit {
                TestModule(expectation: moduleBuilderExpectations.loopTestExpectation)
            }
            if condition {
                TestModule(expectation: moduleBuilderExpectations.conditionalTestExpectation)
            }
            // The `#available(iOS 16, *)` mark is used to test `#available` in a result builder.
            // The availability check is not part of any part of the Spezi API.
            if #available(iOS 16, *) { // swiftlint:disable:this deployment_target
                TestModule(expectation: moduleBuilderExpectations.availableConditionalTestExpectation)
            }
            if condition {
                TestModule(expectation: moduleBuilderExpectations.ifTestExpectation)
            } else {
                TestModule(expectation: moduleBuilderExpectations.elseTestExpectation)
            }
        }
        return modules
    }
    
    
    @Test
    func moduleBuilderIf() async {
        let moduleBuilderExpectations = ModuleBuilderExpectations(
            loopTestExpectation: TestExpectation(expectedCount: 5),
            elseTestExpectation: TestExpectation(expectedCount: 0)
        )
        
        let modules = modules(
            loopLimit: 5,
            condition: true,
            moduleBuilderExpectations: moduleBuilderExpectations
        )
        
        for module in DependencyManager.resolveWithoutErrors(modules.elements) {
            module.configure()
        }
        
        await moduleBuilderExpectations.fulfillment()
    }
    
    @Test
    func moduleBuilderElse() async {
        let moduleBuilderExpectations = ModuleBuilderExpectations(
            loopTestExpectation: TestExpectation(expectedCount: 3),
            conditionalTestExpectation: TestExpectation(expectedCount: 0),
            ifTestExpectation: TestExpectation(expectedCount: 0)
        )
        
        let modules = modules(
            loopLimit: 3,
            condition: false,
            moduleBuilderExpectations: moduleBuilderExpectations
        )
        
        for module in DependencyManager.resolveWithoutErrors(modules.elements) {
            module.configure()
        }
        
        await moduleBuilderExpectations.fulfillment()
    }
}
