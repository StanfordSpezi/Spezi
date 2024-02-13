//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ViewModifierTests: XCTestCase {
    func testViewModifierPropertyWrapper() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["ViewModifier"].tap()
        
        XCTAssert(app.staticTexts["Passed"].waitForExistence(timeout: 1))
    }
}
