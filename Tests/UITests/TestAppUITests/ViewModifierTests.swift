//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ViewModifierTests: XCTestCase {
    @MainActor
    func testViewModifierPropertyWrapper() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        app.buttons["ViewModifier"].tap()

        XCTAssertFalse(app.alerts["Test Failed"].waitForExistence(timeout: 1))
        XCTAssert(app.staticTexts["Passed"].waitForExistence(timeout: 1))
    }
}
