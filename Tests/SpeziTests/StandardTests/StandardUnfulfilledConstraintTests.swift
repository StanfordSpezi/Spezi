//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import SwiftUI
import XCTest
import XCTRuntimeAssertions


private protocol UnfulfilledExampleConstraint: Standard {
    func thisFunctionWouldBeNice()
}


final class StandardUnfulfilledConstraintTests: XCTestCase {
    final class StandardUCTestModule: Module {
        @StandardActor private var standard: any UnfulfilledExampleConstraint
        
        
        func configure() {
            Task {
                await standard.thisFunctionWouldBeNice()
            }
        }
    }
    

    @MainActor
    func testStandardUnfulfilledConstraint() throws {
        let configuration = Configuration(standard: MockStandard()) {}
        let spezi = Spezi(from: configuration)

        XCTAssertThrowsError(try spezi.loadModules([StandardUCTestModule()], ownership: .spezi)) { error in
            guard let moduleError = error as? SpeziModuleError,
                  case let .property(propertyError) = moduleError,
                  case let .unsatisfiedStandardConstraint(constraint, standard) = propertyError else {
                XCTFail("Encountered unexpected error: \(error)")
                return
            }
            XCTAssertEqual(constraint, "UnfulfilledExampleConstraint")
            XCTAssertEqual(standard, "MockStandard")
        }
    }
}
