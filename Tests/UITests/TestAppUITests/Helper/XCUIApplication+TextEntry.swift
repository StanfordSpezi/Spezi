//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


extension XCUIApplication {
    func testPrimaryButton(enabled: Bool, title: String, navigationBarButtonTitle: String? = nil) {
        let navigationBarButtonTitle = navigationBarButtonTitle ?? title
        
        if self.scrollViews.buttons[title].waitForExistence(timeout: 1) {
            self.scrollViews.buttons[title].tap()
        } else if self.collectionViews.buttons[title].waitForExistence(timeout: 1) {
            self.collectionViews.buttons[title].tap()
        } else {
            XCTAssert(self.buttons[title].waitForExistence(timeout: 1))
            self.buttons[title].tap()
        }
        
        if enabled {
            guard !self.scrollViews.buttons["\(title), In progress"].waitForExistence(timeout: 1) else {
                return
            }
            guard !self.collectionViews.buttons["\(title), In progress"].waitForExistence(timeout: 1) else {
                return
            }
            XCTAssert(self.buttons["\(title), In progress"].waitForExistence(timeout: 1))
        } else {
            XCTAssert(self.navigationBars.buttons[navigationBarButtonTitle].waitForExistence(timeout: 1))
            
            if self.scrollViews.buttons[title].waitForExistence(timeout: 1) {
                self.scrollViews.buttons[title].swipeDown()
            } else if self.collectionViews.buttons[title].waitForExistence(timeout: 1) {
                self.collectionViews.buttons[title].swipeDown()
            } else {
                self.buttons[title].swipeDown()
            }
        }
    }
}
