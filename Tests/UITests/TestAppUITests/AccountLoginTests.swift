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
        
        app.enter(value: String(username.dropLast(4)), in: usernameField)
        app.enter(value: password, in: passwordField, secureTextField: true)
        
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
        app.delete(count: username.count, in: username.field)
        app.delete(count: password.count, in: password.field, secureTextField: true)
    }
    
    private func enterCredentials(username: (field: String, value: String), password: (field: String, value: String)) throws {
        let app = XCUIApplication()
        let buttonTitle = "Login"
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        app.enter(value: username.value, in: username.field)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        app.enter(value: password.value, in: password.field, secureTextField: true)
        app.testPrimaryButton(enabled: true, title: buttonTitle)
    }
}
