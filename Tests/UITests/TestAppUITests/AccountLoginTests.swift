//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class AccountLoginTests: TestAppUITests {
    func testLoginUsernameComponents() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["Login"].tap()
        app.buttons["Username and Password"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Login"].exists)
        
        let usernameField = "Enter your username ..."
        let passwordField = "Enter your password ..."
        let username = "lelandstanford"
        let password = "StanfordRocks123!"
        
        try enterCredentials(
            username: (usernameField, username),
            password: (passwordField, String(password.dropLast(2)))
        )
        
        XCTAssertTrue(XCUIApplication().alerts["Credentials do not match"].waitForExistence(timeout: 6.0))
        XCUIApplication().alerts["Credentials do not match"].scrollViews.otherElements.buttons["OK"].tap()
        
        try delete(
            username: (usernameField, username.count),
            password: (passwordField, password.count)
        )
        
        try enterCredentials(
            username: (usernameField, username),
            password: (passwordField, password)
        )
        
        XCTAssertTrue(app.collectionViews.staticTexts[username].waitForExistence(timeout: 6.0))
    }
    
    func testLoginEmailComponents() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["Login"].tap()
        app.buttons["Email and Password"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Login"].exists)
        
        let usernameField = "Enter your email ..."
        let passwordField = "Enter your password ..."
        let username = "lelandstanford@stanford.edu"
        let password = "StanfordRocks123!"
        
        app.textFields[usernameField].tap()
        app.textFields[usernameField].typeText(String(username.dropLast(4)))
        
        app.secureTextFields[passwordField].tap()
        app.secureTextFields[passwordField].typeText(password)
        
        XCTAssertTrue(app.staticTexts["The entered email is not correct."].exists)
        XCTAssertFalse(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
        
        try delete(
            username: (usernameField, username.dropLast(4).count),
            password: (passwordField, password.count)
        )
        
        try enterCredentials(
            username: (usernameField, username),
            password: (passwordField, String(password.dropLast(2)))
        )
        
        XCTAssertTrue(XCUIApplication().alerts["Credentials do not match"].waitForExistence(timeout: 6.0))
        XCUIApplication().alerts["Credentials do not match"].scrollViews.otherElements.buttons["OK"].tap()
        
        try delete(
            username: (usernameField, username.count),
            password: (passwordField, password.count)
        )
        
        try enterCredentials(
            username: (usernameField, username),
            password: (passwordField, password)
        )
        
        XCTAssertTrue(app.collectionViews.staticTexts[username].waitForExistence(timeout: 6.0))
    }
    
    private func delete(username: (field: String, count: Int), password: (field: String, count: Int)) throws {
        let app = XCUIApplication()
        
        app.textFields[username.field].coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        app.textFields[username.field].typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: username.count))
        app.secureTextFields[password.field].coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        app.secureTextFields[password.field].typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: password.count))
    }
    
    private func enterCredentials(username: (field: String, value: String), password: (field: String, value: String)) throws {
        let app = XCUIApplication()
        
        app.scrollViews.otherElements.buttons["Login"].tap()
        XCTAssertFalse(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.navigationBars.buttons["Login"].exists)
        
        app.textFields[username.field].tap()
        app.textFields[username.field].typeText(username.value)
        
        app.scrollViews.otherElements.buttons["Login"].tap()
        XCTAssertFalse(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.navigationBars.buttons["Login"].exists)
        
        app.secureTextFields[password.field].tap()
        app.secureTextFields[password.field].typeText(password.value)
        
        app.scrollViews.otherElements.buttons["Login"].tap()
        XCTAssertFalse(app.navigationBars.buttons["Login"].exists)
        XCTAssertTrue(app.scrollViews.otherElements.buttons["Login, In progress"].waitForExistence(timeout: 0.5))
    }
}
