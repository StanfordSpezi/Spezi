//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class LocalStorageTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = true
    }
    
    
    func testLocalStorage() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.collectionViews.buttons["LocalStorage"].tap()
        
        XCTAssertTrue(app.staticTexts["Passed"].waitForExistence(timeout: 5))
        
        print(app.staticTexts.debugDescription)
    }
}
