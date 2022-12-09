//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class UserProfileViewTests: TestAppUITests {
    func testProfileViews() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["User Profile View"].tap()
        
        XCTAssertTrue(app.staticTexts["PS"].exists)
        XCTAssertTrue(app.staticTexts["LS"].exists)
        
        XCTAssertTrue(app.images["person.crop.artframe"].waitForExistence(timeout: 1.0))
    }
}
