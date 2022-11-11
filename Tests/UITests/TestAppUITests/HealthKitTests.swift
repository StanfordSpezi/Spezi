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
        
        
        func navigateToElement() { // swiftlint:disable:this cyclomatic_complexity
            let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
            
            healthApp.navigationBars["Browse"].searchFields["Search"].tap()
            let clearTestButton = healthApp.navigationBars["Browse"].searchFields["Search"].buttons["Clear text"]
            if clearTestButton.exists {
                clearTestButton.tap()
            }
            healthApp.navigationBars["Browse"].searchFields["Search"].typeText(rawValue)
            
            if !findElementInCollectionView(in: healthApp) {
                healthApp.navigationBars["Browse"].buttons["Cancel"].tap()
                
                switch self {
                case .activeEnergy:
                    healthApp.collectionViews.staticTexts["UIA.Health.Browse.HKDisplayCategoryIdentifierFitness.Title"].tap()
                    if !findElementInCollectionView(in: healthApp) {
                        healthApp.collectionViews.staticTexts["Active Energy"].tap()
                    }
                case .restingHeartRate:
                    healthApp.collectionViews.staticTexts["UIA.Health.Browse.HKDisplayCategoryIdentifierHeart.Title"].tap()
                    if !findElementInCollectionView(in: healthApp) {
                        healthApp.collectionViews.firstMatch.swipeUp(velocity: .slow)
                        healthApp.collectionViews.staticTexts["Resting Heart Rate"].tap()
                    }
                case .electrocardiograms:
                    healthApp.collectionViews.staticTexts["UIA.Health.Browse.HKDisplayCategoryIdentifierHeart.Title"].tap()
                    if !findElementInCollectionView(in: healthApp) {
                        healthApp.collectionViews.firstMatch.swipeUp(velocity: .slow)
                        healthApp.collectionViews.staticTexts["Electrocardiograms (ECG)"].tap()
                    }
                case .steps:
                    healthApp.collectionViews.staticTexts["UIA.Health.Browse.HKDisplayCategoryIdentifierFitness.Title"].tap()
                    if !findElementInCollectionView(in: healthApp) {
                        healthApp.collectionViews.firstMatch.swipeUp(velocity: .slow)
                        healthApp.collectionViews.staticTexts["Steps"].tap()
                    }
                case .pushes:
                    healthApp.collectionViews.staticTexts["UIA.Health.Browse.HKDisplayCategoryIdentifierFitness.Title"].tap()
                    if !findElementInCollectionView(in: healthApp) {
                        healthApp.collectionViews.firstMatch.swipeUp(velocity: .slow)
                        healthApp.collectionViews.staticTexts["Pushes"].tap()
                    }
                }
            }
        }
        
        private func findElementInCollectionView(in healthApp: XCUIApplication) -> Bool {
            let findByNamePredicate = NSPredicate(format: "label CONTAINS[cd] %@", rawValue)
            let headerTitlePredicate = NSPredicate(format: "label CONTAINS[cd] %@", "Header.Title")
            let findByNamePredicateElement = healthApp.collectionViews.staticTexts.element(matching: findByNamePredicate).firstMatch
            let headerTitlePredicateElement = healthApp.collectionViews.staticTexts.element(matching: headerTitlePredicate).firstMatch
            
            if findByNamePredicateElement.exists {
                findByNamePredicateElement.tap()
                return true
            } else if headerTitlePredicateElement.exists {
                headerTitlePredicateElement.tap()
                return true
            }
            return false
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

        exitAppAndOpenHealth(.electrocardiograms)
        exitAppAndOpenHealth(.steps)
        exitAppAndOpenHealth(.pushes)
        exitAppAndOpenHealth(.restingHeartRate)
        exitAppAndOpenHealth(.activeEnergy)
        
        app.collectionViews.buttons["HealthKit"].tap()
        
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

        exitAppAndOpenHealth(.electrocardiograms)

        sleep(1)

        XCTAssertEqual(
            HealthDataType.numberOfHKTypeNames(in: app),
            HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 1, pushes: 1)
        )

        exitAppAndOpenHealth(.steps)

        sleep(1)

        XCTAssertEqual(
            HealthDataType.numberOfHKTypeNames(in: app),
            HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 1)
        )

        exitAppAndOpenHealth(.pushes)

        sleep(1)

        XCTAssertEqual(
            HealthDataType.numberOfHKTypeNames(in: app),
            HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 2)
        )

        exitAppAndOpenHealth(.restingHeartRate)

        sleep(1)

        XCTAssertEqual(
            HealthDataType.numberOfHKTypeNames(in: app),
            HealthDataType.NumberOfHKTypeNames(activeEnergy: 1, restingHeartRate: 1, electrocardiograms: 2, steps: 2, pushes: 2)
        )

        exitAppAndOpenHealth(.activeEnergy)

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
    
    
    func exitAppAndOpenHealth(_ healthDataType: HealthDataType) {
        XCUIDevice.shared.press(.home)
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert in
            if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
                return true
            }
            return false
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
        
        healthDataType.navigateToElement()

        healthApp.navigationBars.firstMatch.buttons["Add Data"].tap()
        
        healthDataType.addData()
        
        healthApp.navigationBars.firstMatch.buttons["Add"].tap()
        healthApp.terminate()
        
        let testApp = XCUIApplication()
        testApp.activate()
    }
}
