//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


class ObservableObjectTests: TestAppTestCase {
    let testAppComponent: ObservableComponentTestsComponent<TestAppStandard>
    
    
    init(testAppComponent: ObservableComponentTestsComponent<TestAppStandard>) {
        self.testAppComponent = testAppComponent
    }
    
    
    func runTests() async throws {
        try XCTAssertEqual(testAppComponent.message, "Passed")
    }
}
