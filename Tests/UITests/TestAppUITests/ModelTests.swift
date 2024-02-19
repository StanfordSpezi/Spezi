//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ModelTests: XCTestCase {
    func testModelPropertyWrapper() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Model"].tap()

        XCTAssert(app.staticTexts["Passed"].waitForExistence(timeout: 1))
    }
}
