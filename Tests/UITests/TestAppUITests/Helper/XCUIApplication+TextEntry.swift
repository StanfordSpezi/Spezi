//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
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
    
    func testPrimaryButton(enabled: Bool, title: String, navigationBarButtonTitle: String? = nil) {
        let navigationBarButtonTitle = navigationBarButtonTitle ?? title
        
        if self.scrollViews.buttons[title].waitForExistence(timeout: 0.5) {
            self.scrollViews.buttons[title].tap()
        } else if self.collectionViews.buttons[title].waitForExistence(timeout: 0.5) {
            self.collectionViews.buttons[title].tap()
        } else {
            XCTAssert(self.buttons[title].waitForExistence(timeout: 0.5))
            self.buttons[title].tap()
        }
        
        if enabled {
            guard !self.scrollViews.buttons["\(title), In progress"].waitForExistence(timeout: 1.0) else {
                return
            }
            guard !self.collectionViews.buttons["\(title), In progress"].waitForExistence(timeout: 1.0) else {
                return
            }
            XCTAssert(self.buttons["\(title), In progress"].waitForExistence(timeout: 1.0))
        } else {
            XCTAssert(self.navigationBars.buttons[navigationBarButtonTitle].exists)
            
            if self.scrollViews.buttons[title].exists {
                self.scrollViews.buttons[title].swipeDown()
            } else if self.collectionViews.buttons[title].exists {
                self.collectionViews.buttons[title].swipeDown()
            } else {
                self.buttons[title].swipeDown()
            }
        }
    }
}
