//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class RemoteNotificationsTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
    }

    @MainActor
    func testRegistrationOnSimulator() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        XCTAssertTrue(app.buttons["Remote Notifications"].waitForExistence(timeout: 2.0))
        app.buttons["Remote Notifications"].tap()

        XCTAssertTrue(app.navigationBars["Remote Notifications"].waitForExistence(timeout: 2.0))
        XCTAssertTrue(app.staticTexts["Token, none"].exists)
        XCTAssertTrue(app.buttons["Register"].exists)
        XCTAssertTrue(app.buttons["Unregister"].exists)

        app.buttons["Register"].tap()

        if !(app.staticTexts["Token, 80 bytes"].waitForExistence(timeout: 1.0)
             || app.staticTexts["Token, 60 bytes"].exists) {
            XCTAssertFalse(app.staticTexts["Token, failed"].exists)
            XCTAssertTrue(app.staticTexts["Token, Timeout"].waitForExistence(timeout: 10))
            print("The token registration timed out!")
        }

        app.buttons["Unregister"].tap()
        XCTAssertTrue(app.staticTexts["Token, none"].waitForExistence(timeout: 1.0))
    }
}
