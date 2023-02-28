//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


final class AccountSignUpTests: TestAppUITests {
    func testSignUpUsernameComponents() throws {
        try disablePasswordAutofill()
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["SignUp"].tap()
        app.buttons["Username and Password"].tap()
        
        let usernameField = "Enter your username ..."
        let username = "lelandstanford"
        let usernameReplacement = "lelandstanford2"
        
        try signUpUsername(
            usernameField: usernameField,
            username: username,
            usernameReplacement: usernameReplacement
        )
    }
    
    func testSignUpEmailComponents() throws {
        try disablePasswordAutofill()
        
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Account"].tap()
        app.buttons["SignUp"].tap()
        app.buttons["Email and Password"].tap()
        
        let usernameField = "Enter your email ..."
        let username = "lelandstanford@stanford.edu"
        let usernameReplacement = "lelandstanford2@stanford.edu"
        
        try signUpUsername(
            usernameField: usernameField,
            username: username,
            usernameReplacement: usernameReplacement
        ) {
            try app.textFields[usernameField].enter(value: String(username.dropLast(4)))
            app.testPrimaryButton(enabled: false, title: "Sign Up")
            
            XCTAssertTrue(app.staticTexts["The entered email is not correct."].waitForExistence(timeout: 5.0))
            
            try app.textFields[usernameField].delete(count: username.count)
        }
    }
    
    func signUpUsername(
        usernameField: String,
        username: String,
        usernameReplacement: String,
        initialTests: () throws -> Void = { }
    ) throws {
        let app = XCUIApplication()
        let buttonTitle = "Sign Up"
        
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        try initialTests()
        
        try app.textFields[usernameField].enter(value: username)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        let passwordField = "Enter your password ..."
        let password = "StanfordRocks123!"
        try app.secureTextFields[passwordField].enter(value: password)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        let passwordRepeatField = "Repeat your password ..."
        var passwordRepeat = "StanfordRocks123"
        try app.secureTextFields[passwordRepeatField].enter(value: passwordRepeat)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        XCTAssertTrue(app.staticTexts["The entered passwords are not equal."].waitForExistence(timeout: 1.0))
        
        try app.secureTextFields[passwordRepeatField].delete(count: passwordRepeat.count)
        passwordRepeat = password
        try app.secureTextFields[passwordRepeatField].enter(value: passwordRepeat)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        app.datePickers.firstMatch.tap()
        app.staticTexts["Date of Birth"].tap()
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        app.staticTexts["Choose not to answer"].tap()
        app.buttons["Male"].tap()
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        let givenNameField = "Enter your first name ..."
        let givenName = "Leland"
        try app.textFields[givenNameField].enter(value: givenName)
        app.testPrimaryButton(enabled: false, title: buttonTitle)
        
        let familyNameField = "Enter your last name ..."
        let familyName = "Stanford"
        try app.textFields[familyNameField].enter(value: familyName)
        app.testPrimaryButton(enabled: true, title: buttonTitle)
        
        XCTAssertTrue(app.alerts["Username is already taken"].waitForExistence(timeout: 10.0))
        app.alerts["Username is already taken"].scrollViews.otherElements.buttons["OK"].tap()
        
        app.swipeDown()
        try app.textFields[usernameField].delete(count: username.count)
        try app.textFields[usernameField].enter(value: usernameReplacement)
        app.testPrimaryButton(enabled: true, title: buttonTitle)
        
        XCTAssertTrue(app.collectionViews.staticTexts[usernameReplacement].waitForExistence(timeout: 10.0))
    }
}
