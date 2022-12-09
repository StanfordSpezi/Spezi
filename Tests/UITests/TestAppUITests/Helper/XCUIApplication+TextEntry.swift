//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


extension XCUIApplication {
    func textField(_ field: String, secure: Bool) -> XCUIElement {
        if secure {
            return secureTextFields[field]
        } else {
            return textFields[field]
        }
    }
    
    func delete(count: Int, in field: String, secureTextField: Bool = false) {
        let textField = textField(field, secure: secureTextField)
        textField.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        textField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: count))
    }
    
    func enter(value: String, in field: String, secureTextField: Bool = false) {
        let textField = textField(field, secure: secureTextField)
        textField.tap()
        textField.typeText(value)
    }
    
    func testPrimaryButton(enabled: Bool) {
        self.collectionViews.buttons["Sign Up"].tap()
        if enabled {
            XCTAssert(self.collectionViews.buttons["Sign Up, In progress"].waitForExistence(timeout: 0.5))
        } else {
            XCTAssert(self.navigationBars.buttons["Sign Up"].exists)
            self.collectionViews.buttons["Sign Up"].swipeDown()
        }
    }
}
