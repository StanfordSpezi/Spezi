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
        XCTAssertTrue(app.staticTexts["Token, 80 bytes"].waitForExistence(timeout: 1.0))

        app.buttons["Unregister"].tap()
        XCTAssertTrue(app.staticTexts["Token, none"].waitForExistence(timeout: 1.0))
    }
}
