//
//  XCTestCase+DiableAutofillPassword.swift
//  TestAppUITests
//
//  Created by Paul Shmiedmayer on 2/9/23.
//

import XCTest


extension XCTestCase {
    /// Navigates to the iOS settings app and disables the password autofill functionality.
    public func disablePasswordAutofill() {
        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settingsApp.terminate()
        settingsApp.launch()
        
        if settingsApp.staticTexts["PASSWORDS"].waitForExistence(timeout: 0.5) {
            settingsApp.staticTexts["PASSWORDS"].tap()
        }
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        if springboard.secureTextFields["Passcode field"].waitForExistence(timeout: 20) {
            let passcodeInput = springboard.secureTextFields["Passcode field"]
            passcodeInput.tap()
            passcodeInput.typeText("1234\r")
        } else {
            XCTFail("Could not enter the passcode in the device to enter the password section in the settings app.")
            return
        }
        
        XCTAssertTrue(settingsApp.tables.cells["PasswordOptionsCell"].waitForExistence(timeout: 5.0))
        settingsApp.tables.cells["PasswordOptionsCell"].buttons["chevron"].tap()
        if settingsApp.switches["AutoFill Passwords"].value as? String == "1" {
            settingsApp.switches["AutoFill Passwords"].tap()
        }
    }
}
