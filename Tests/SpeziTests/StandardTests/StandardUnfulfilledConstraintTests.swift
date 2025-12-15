//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) @testable import Spezi
import Testing


private protocol UnfulfilledExampleConstraint: Standard {
    func thisFunctionWouldBeNice()
}


struct StandardUnfulfilledConstraintTests {
    final class StandardUCTestModule: Module {
        @StandardActor private var standard: any UnfulfilledExampleConstraint
        
        func configure() {
            Task {
                await standard.thisFunctionWouldBeNice()
            }
        }
    }
    
    @Test
    @MainActor
    func standardUnfulfilledConstraint() throws {
        let configuration = Configuration(standard: MockStandard()) {}
        let spezi = Spezi(from: configuration)
        #expect {
            try spezi.loadModules([StandardUCTestModule()], ownership: .spezi)
        } throws: { error in
            guard let moduleError = error as? SpeziModuleError,
                  case let .property(propertyError) = moduleError,
                  case let .unsatisfiedStandardConstraint(constraint, standard) = propertyError else {
                Issue.record("Encountered unexpected error: \(error)")
                return false
            }
            #expect(constraint == "UnfulfilledExampleConstraint")
            #expect(standard == "MockStandard")
            return true
        }
    }
}
