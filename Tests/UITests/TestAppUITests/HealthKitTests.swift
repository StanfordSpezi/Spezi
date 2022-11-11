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
            case .activeEnergy:
                return "Activity"
            case .restingHeartRate:
                return "Heart"
            case .electrocardiograms:
                return "Heart"
            case .steps:
                return "Activity"
            case .pushes:
                return "Activity"
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
            healthApp.collectionViews.staticTexts.allElementsBoundByIndex.filter { $0.label.contains(type.hkTypeNames) } .count
        }
        
        
        func navigateToElement() throws {
            let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
            
            if healthApp.navigationBars["Browse"].buttons["Cancel"].exists {
                healthApp.navigationBars["Browse"].buttons["Cancel"].tap()
            }
            try findOverviewInCollectionView(in: healthApp)
        }
        
        private func findOverviewInCollectionView(in healthApp: XCUIApplication) throws {
            let findByNamePredicate = NSPredicate(format: "label CONTAINS[cd] %@", self.category)
            let findByNamePredicateStaticText = healthApp.collectionViews.staticTexts.element(matching: findByNamePredicate).firstMatch
            let findByNamePredicateImage = healthApp.collectionViews.images.element(matching: findByNamePredicate).firstMatch
            
            if findByNamePredicateStaticText.waitForExistence(timeout: 3) {
                findByNamePredicateStaticText.tap()
            } else if findByNamePredicateImage.waitForExistence(timeout: 3) {
                findByNamePredicateImage.tap()
            } else {
                XCTFail("Failed not find element in collection view: \(healthApp.staticTexts.allElementsBoundByIndex)")
                throw XCTestError(.failureWhileWaiting)
            }
            
            try findElementInCollectionView(in: healthApp)
        }
        
        private func findElementInCollectionView(in healthApp: XCUIApplication) throws {
            let findByRawValuePredicate = NSPredicate(format: "label CONTAINS[cd] %@", rawValue)
            var findByRawValuePredicateElement = healthApp.collectionViews.staticTexts.element(matching: findByRawValuePredicate).firstMatch
            
            guard findByRawValuePredicateElement.waitForExistence(timeout: 3) else {
                healthApp.collectionViews.firstMatch.swipeUp(velocity: .slow)
                findByRawValuePredicateElement = healthApp.collectionViews.staticTexts.element(matching: findByRawValuePredicate).firstMatch
                if findByRawValuePredicateElement.waitForExistence(timeout: 3) {
                    findByRawValuePredicateElement.tap()
                    return
                }
                XCTFail("Failed not find element in collection view: \(healthApp.staticTexts.allElementsBoundByIndex)")
                throw XCTestError(.failureWhileWaiting)
            }
            
            findByRawValuePredicateElement.tap()
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
        let app = XCUIApplication()
        app.launch()
        
        try exitAppAndOpenHealth(.electrocardiograms)
        try exitAppAndOpenHealth(.steps)
        try exitAppAndOpenHealth(.pushes)
        try exitAppAndOpenHealth(.restingHeartRate)
        try exitAppAndOpenHealth(.activeEnergy)
        
        app.collectionViews.buttons["HealthKit"].tap()
        
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
    }
    
    
    func exitAppAndOpenHealth(_ healthDataType: HealthDataType) throws {
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
