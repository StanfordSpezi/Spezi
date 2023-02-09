//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTHealthKit


final class HealthKitTests: TestAppUITests {
    func testHealthKit() throws { // swiftlint:disable:this function_body_length
        let app = XCUIApplication()
        app.launch()
        
        try exitAppAndOpenHealth(.electrocardiograms)
        try exitAppAndOpenHealth(.steps)
        try exitAppAndOpenHealth(.pushes)
        try exitAppAndOpenHealth(.restingHeartRate)
        try exitAppAndOpenHealth(.activeEnergy)
        
        app.buttons["HealthKit"].tap()
        
        XCTAssert(app.buttons["Ask for authorization"].waitForExistence(timeout: 2))
        app.buttons["Ask for authorization"].tap()
        
        if !app.navigationBars["Health Access"].waitForExistence(timeout: 10) {
            print("The HealthKit View did not load after 10 seconds ... give it a second try with a timeout of 20 seconds.")
            app.buttons["Ask for authorization"].tap()
        }
        if app.navigationBars["Health Access"].waitForExistence(timeout: 20) {
            app.tables.staticTexts["Turn On All"].tap()
            app.navigationBars["Health Access"].buttons["Allow"].tap()
        }
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 1,
                HealthAppDataType.restingHeartRate.rawValue: 0,
                HealthAppDataType.electrocardiograms.rawValue: 1,
                HealthAppDataType.steps.rawValue: 1,
                HealthAppDataType.pushes.rawValue: 1
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 1,
                HealthAppDataType.restingHeartRate.rawValue: 1,
                HealthAppDataType.electrocardiograms.rawValue: 1,
                HealthAppDataType.steps.rawValue: 1,
                HealthAppDataType.pushes.rawValue: 1
            ]
        )
        
        try exitAppAndOpenHealth(.electrocardiograms)
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 1,
                HealthAppDataType.restingHeartRate.rawValue: 1,
                HealthAppDataType.electrocardiograms.rawValue: 2,
                HealthAppDataType.steps.rawValue: 1,
                HealthAppDataType.pushes.rawValue: 1
            ]
        )
        
        try exitAppAndOpenHealth(.steps)
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 1,
                HealthAppDataType.restingHeartRate.rawValue: 1,
                HealthAppDataType.electrocardiograms.rawValue: 2,
                HealthAppDataType.steps.rawValue: 2,
                HealthAppDataType.pushes.rawValue: 1
            ]
        )
        
        try exitAppAndOpenHealth(.pushes)
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 1,
                HealthAppDataType.restingHeartRate.rawValue: 1,
                HealthAppDataType.electrocardiograms.rawValue: 2,
                HealthAppDataType.steps.rawValue: 2,
                HealthAppDataType.pushes.rawValue: 2
            ]
        )
        
        try exitAppAndOpenHealth(.restingHeartRate)
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 1,
                HealthAppDataType.restingHeartRate.rawValue: 1,
                HealthAppDataType.electrocardiograms.rawValue: 2,
                HealthAppDataType.steps.rawValue: 2,
                HealthAppDataType.pushes.rawValue: 2
            ]
        )

        try exitAppAndOpenHealth(.activeEnergy)
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 2,
                HealthAppDataType.restingHeartRate.rawValue: 1,
                HealthAppDataType.electrocardiograms.rawValue: 2,
                HealthAppDataType.steps.rawValue: 2,
                HealthAppDataType.pushes.rawValue: 2
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.rawValue: 2,
                HealthAppDataType.restingHeartRate.rawValue: 2,
                HealthAppDataType.electrocardiograms.rawValue: 2,
                HealthAppDataType.steps.rawValue: 2,
                HealthAppDataType.pushes.rawValue: 2
            ]
        )
    }
}
