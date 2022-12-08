//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


class TestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
        
        if let failureCount = testRun?.failureCount, failureCount > 0 {
          takeScreenshot()
        }
    }
    
    
    func runTestAppUITests(feature: String, timeout: TimeInterval = 0.5) throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons[feature].tap()
        
        XCTAssertTrue(app.staticTexts["Passed"].waitForExistence(timeout: timeout))
        
        print(app.staticTexts.debugDescription)
    }
}
