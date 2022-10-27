//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ObservableObjectComponentTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    

    func testObservableObjectComponent() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].buttons["ObservableObjectTests"].tap()
        
        XCTAssertTrue(app.images["Globe"].exists)
        XCTAssertTrue(app.staticTexts["Hello, Paul!"].waitForExistence(timeout: 2))
    }
}
