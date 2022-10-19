//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest


//final class ConfigurationTests: XCTestCase {
//    class TestApplicationDelegate: CardinalKitAppDelegate<MockStandard> {
//        @ConfigurationBuilder<MockStandard>
//        override var configuration: TupleConfiguration<MockStandard> {
//            TestConfiguration(expectation: configurationExpecation)
//        }
//    }
//    
//    
//    private static let configurationExpecation: XCTestExpectation = {
//        let expectation = XCTestExpectation(description: "Configuration")
//        expectation.assertForOverFulfill = true
//        return expectation
//    }()
//    
//    
//    func testConfigurationFlow() throws {
//        _ = try XCTUnwrap(
//            Text("CardinalKit")
//                .cardinalKit(TestApplicationDelegate()) as? ModifiedContent<Text, CardinalKitViewModifier<MockStandard>>
//        )
//        wait(for: [ConfigurationTests.configurationExpecation], timeout: 0.1)
//    }
//}
