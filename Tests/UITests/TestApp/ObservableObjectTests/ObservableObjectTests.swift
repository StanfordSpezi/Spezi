//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import XCTCardinalKit
import XCTestApp


class ObservableObjectTests: TestAppTestCase {
    typealias ObservableComponent = ObservableComponentTestsComponent<TestAppStandard>
    typealias MultipleObservableComponent = MultipleObservableObjectsTestsComponent<TestAppStandard>
    
    let testAppComponent: ObservableComponent
    let multipleObservableInt: MultipleObservableComponent.TestObservableObject<Int>
    let multipleObservableString: MultipleObservableComponent.TestObservableObject<String>
    
    
    init(
        testAppComponent: ObservableComponent,
        multipleObservableInt: MultipleObservableComponent.TestObservableObject<Int>,
        multipleObservableString: MultipleObservableComponent.TestObservableObject<String>
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
