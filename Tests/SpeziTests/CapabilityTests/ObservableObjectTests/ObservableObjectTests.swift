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


final class ObservableObjectTests: XCTestCase {
    func testObservableObjectsRetrieval() throws {
        let expectation = XCTestExpectation(description: "Component")
        expectation.assertForOverFulfill = true
        
        let testApplicationDelegate = TestApplicationDelegate(expectation: expectation)
        
        let observableObjectProviders = testApplicationDelegate.spezi.observableObjectProviders
        XCTAssertEqual(observableObjectProviders.count, 1)
        _ = try XCTUnwrap(observableObjectProviders.first as? TestComponent<MockStandard>)
    }
    
    func testNoObservableObjectsRetrieval() {
        let speziAppDelegate = SpeziAppDelegate()
        XCTAssert(speziAppDelegate.spezi.observableObjectProviders.isEmpty)
    }
}
