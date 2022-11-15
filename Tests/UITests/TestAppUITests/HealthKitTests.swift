//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class HealthKitTests: TestAppUITests {
    enum HealthDataType: String {
        case activeEnergy = "Active Energy"
        case restingHeartRate = "Resting Heart Rate"
        case electrocardiograms = "Electrocardiograms (ECG)"
        case steps = "Steps"
        case pushes = "Pushes"
        
        
        struct NumberOfHKTypeNames: Equatable {
            let activeEnergy: Int
            let restingHeartRate: Int
            let electrocardiograms: Int
            let steps: Int
            let pushes: Int
        }
        
        
        var hkTypeNames: String {
            switch self {
            case .activeEnergy:
                return "HKQuantityTypeIdentifierActiveEnergyBurned"
            case .restingHeartRate:
                return "HKQuantityTypeIdentifierRestingHeartRate"
            case .electrocardiograms:
                return "HKDataTypeIdentifierElectrocardiogram"
            case .steps:
                return "HKQuantityTypeIdentifierStepCount"
            case .pushes:
                return "HKQuantityTypeIdentifierPushCount"
            }
        }
        
        var category: String {
            switch self {
            case .activeEnergy, .steps, .pushes:
                return "Activity"
            case .restingHeartRate, .electrocardiograms:
                return "Heart"
            }
        }
        
        
        static func numberOfHKTypeNames(in healthApp: XCUIApplication) -> NumberOfHKTypeNames {
            NumberOfHKTypeNames(
                activeEnergy: numberOfHKTypeNames(in: healthApp, ofType: .activeEnergy),
                restingHeartRate: numberOfHKTypeNames(in: healthApp, ofType: .restingHeartRate),
                electrocardiograms: numberOfHKTypeNames(in: healthApp, ofType: .electrocardiograms),
                steps: numberOfHKTypeNames(in: healthApp, ofType: .steps),
                pushes: numberOfHKTypeNames(in: healthApp, ofType: .pushes)
            )
        }
        
        static func numberOfHKTypeNames(in healthApp: XCUIApplication, ofType type: HealthDataType) -> Int {
            healthApp.staticTexts.allElementsBoundByIndex.filter { $0.label.contains(type.hkTypeNames) } .count
        }
        
        
        func navigateToElement() throws {
            let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
            
            if healthApp.navigationBars["Browse"].buttons["Cancel"].exists {
                healthApp.navigationBars["Browse"].buttons["Cancel"].tap()
            }
            try findCategoryAndElement(in: healthApp)
        }
        
        private func findCategoryAndElement(in healthApp: XCUIApplication) throws {
            // Find category:
            let categoryStaticTextPredicate = NSPredicate(format: "label CONTAINS[cd] %@", category)
            let categoryStaticText = healthApp.staticTexts.element(matching: categoryStaticTextPredicate).firstMatch
            
            if categoryStaticText.waitForExistence(timeout: 1) {
                categoryStaticText.tap()
            } else {
                XCTFail("Failed to find category: \(healthApp.staticTexts.allElementsBoundByIndex)")
                throw XCTestError(.failureWhileWaiting)
            }
            
            // Find element:
            let elementStaticTextPredicate = NSPredicate(format: "label CONTAINS[cd] %@", rawValue)
            var elementStaticText = healthApp.staticTexts.element(matching: elementStaticTextPredicate).firstMatch
            
            guard elementStaticText.waitForExistence(timeout: 3) else {
                healthApp.firstMatch.swipeUp(velocity: .slow)
                elementStaticText = healthApp.buttons.element(matching: elementStaticTextPredicate).firstMatch
                if elementStaticText.waitForExistence(timeout: 3) {
                    elementStaticText.tap()
                    return
                }
                XCTFail("Failed to find element in category: \(healthApp.staticTexts.allElementsBoundByIndex)")
                throw XCTestError(.failureWhileWaiting)
            }
            
            elementStaticText.tap()
        }
        
        func addData() {
            let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
            
            switch self {
            case .activeEnergy:
                healthApp.tables.textFields["cal"].tap()
                healthApp.tables.textFields["cal"].typeText("42")
            case .restingHeartRate:
                healthApp.tables.textFields["BPM"].tap()
                healthApp.tables.textFields["BPM"].typeText("80")
            case .electrocardiograms:
                healthApp.tables.staticTexts["High Heart Rate"].tap()
            case .steps:
                healthApp.tables.textFields["Steps"].tap()
                healthApp.tables.textFields["Steps"].typeText("42")
            case .pushes:
                healthApp.tables.textFields["Pushes"].tap()
                healthApp.tables.textFields["Pushes"].typeText("42")
            }
        }
    }
    
    
    func testHealthKit() throws { // swiftlint:disable:this function_body_length
        // Due to the problem that GitHub Action Runners do have an empty HealthKit instance we skip the tests on GitHub Action runners:
        if ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] == "/Users/runner" {
            throw XCTSkip("The GitHub Action environment does not support interactions with the HealthApp, therefore we don't run the tests for now.")
        }
        
        do {
            let app = XCUIApplication()
            app.launch()
            
            try exitAppAndOpenHealth(.electrocardiograms)
            try exitAppAndOpenHealth(.steps)
            try exitAppAndOpenHealth(.pushes)
            try exitAppAndOpenHealth(.restingHeartRate)
            try exitAppAndOpenHealth(.activeEnergy)
            
            app.buttons["HealthKit"].tap()
            
            _ = app.buttons["Ask for authorization"].waitForExistence(timeout: 1)
            app.buttons["Ask for authorization"].tap()
            
            _ = app.navigationBars["Health Access"].waitForExistence(timeout: 10)
            if app.navigationBars["Health Access"].waitForExistence(timeout: 10) {
                app.tables.staticTexts["Turn On All"].tap()
                app.navigationBars["Health Access"].buttons["Allow"].tap()
            }
            
            sleep(2)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 0, electrocardiograms: 1, steps: 1, pushes: 1)
            )
            
            app.buttons["Trigger data source collection"].tap()
            
            sleep(2)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 1, steps: 1, pushes: 1)
            )
            
            try exitAppAndOpenHealth(.electrocardiograms)
            
            sleep(1)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 1, pushes: 1)
            )
            
            try exitAppAndOpenHealth(.steps)
            
            sleep(1)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 1)
            )
            
            try exitAppAndOpenHealth(.pushes)
            
            sleep(1)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 2)
            )
            
            try exitAppAndOpenHealth(.restingHeartRate)
            
            sleep(1)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 2)
            )
            
            try exitAppAndOpenHealth(.activeEnergy)
            
            sleep(1)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 2, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 2)
            )
            
            app.buttons["Trigger data source collection"].tap()
            
            sleep(1)
            
            XCTAssertEqual(
                HealthDataType.numberOfHKTypeNames(in: app),
                HealthDataType.NumberOfHKTypeNames(activeEnergy: 2, restingHeartRate: 2, electrocardiograms: 2, steps: 2, pushes: 2)
            )
        } catch {
            let screenshot = XCUIScreen.main.screenshot()
            let fullScreenshotAttachment = XCTAttachment(screenshot: screenshot)
            fullScreenshotAttachment.lifetime = .keepAlways
            
            add(fullScreenshotAttachment)
            throw error
        }
    }
    
    
    private func exitAppAndOpenHealth(_ healthDataType: HealthDataType) throws {
        XCUIDevice.shared.press(.home)
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert in
            guard alert.buttons["Allow"].exists else {
                XCTFail("Failed not dismiss alert: \(alert.staticTexts.allElementsBoundByIndex)")
                return false
            }
            
            alert.buttons["Allow"].tap()
            return true
        }
        
        let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
        healthApp.terminate()
        healthApp.activate()
        
        if healthApp.staticTexts["Welcome to Health"].exists {
            healthApp.staticTexts["Continue"].tap()
            healthApp.staticTexts["Continue"].tap()
            healthApp.tables.buttons["Next"].tap()
            healthApp.staticTexts["Continue"].tap()
        }
        
        guard healthApp.tabBars["Tab Bar"].buttons["Browse"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to identify the Add Data Button: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.tabBars["Tab Bar"].buttons["Browse"].tap()
        
        try healthDataType.navigateToElement()
        
        guard healthApp.navigationBars.firstMatch.buttons["Add Data"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to identify the Add Data Button: \(healthApp.buttons.allElementsBoundByIndex)")
            XCTFail("Failed to identify the Add Data Button: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.navigationBars.firstMatch.buttons["Add Data"].tap()
        
        healthDataType.addData()
        
        guard healthApp.navigationBars.firstMatch.buttons["Add"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to identify the Add button: \(healthApp.buttons.allElementsBoundByIndex)")
            XCTFail("Failed to identify the Add button: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.navigationBars.firstMatch.buttons["Add"].tap()
        
        healthApp.terminate()
        
        let testApp = XCUIApplication()
        testApp.activate()
    }
}
