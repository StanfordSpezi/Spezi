//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import XCTestApp
import XCTSpezi


class ObservableObjectTests: TestAppTestCase {
    let testAppComponent: ObservableComponentTestsComponent
    let multipleObservableInt: MultipleObservableObjectsTestsComponent.TestObservableObject<Int>
    let multipleObservableString: MultipleObservableObjectsTestsComponent.TestObservableObject<String>
    
    
    init(
        testAppComponent: ObservableComponentTestsComponent,
        multipleObservableInt: MultipleObservableObjectsTestsComponent.TestObservableObject<Int>,
        multipleObservableString: MultipleObservableObjectsTestsComponent.TestObservableObject<String>
    ) {
        self.testAppComponent = testAppComponent
        self.multipleObservableInt = multipleObservableInt
        self.multipleObservableString = multipleObservableString
    }
    
    
    func runTests() async throws {
        try XCTAssertEqual(testAppComponent.message, "Passed")
        try XCTAssertEqual(multipleObservableInt.value, 42)
        try XCTAssertEqual(multipleObservableString.value, "42")
    }
}
