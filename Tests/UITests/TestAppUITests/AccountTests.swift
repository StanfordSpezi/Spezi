//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class AccountTests: TestAppUITests {
    func testAccountComponents() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["Login"].tap()
        app.buttons["Username and Password"].tap()
        
        app.scrollViews.otherElements.buttons["Login"].tap()
        XCTAssertFalse(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
        
        app.textFields["Enter your username ..."].tap()
        app.textFields["Enter your username ..."].typeText("lelandstanford@stanford.edu")
        
        app.scrollViews.otherElements.buttons["Login"].tap()
        XCTAssertFalse(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
        
        app.secureTextFields["Enter your password ..."].tap()
        app.secureTextFields["Enter your password ..."].typeText("StanfordRocks123!")
        
        app.scrollViews.otherElements.buttons["Login"].tap()
        XCTAssertTrue(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
        
//        let enterYourUsernameTextField = elementsQuery.textFields["Enter your username ..."]
//        enterYourUsernameTextField.tap()
//        elementsQuery.secureTextFields["Enter your password ..."].tap()
//        elementsQuery.staticTexts["Password"].tap()
//        enterYourUsernameTextField.tap()
//        enterYourUsernameTextField.tap()
//        usernameAndPasswordButton.tap()
//        usernameAndPasswordButton.tap()
//        elementsQuery.buttons["Username and Password, In progress"].tap()
//        usernameAndPasswordButton.tap()
        
    }
    
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
