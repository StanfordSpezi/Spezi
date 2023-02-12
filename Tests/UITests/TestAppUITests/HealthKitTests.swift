//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit


final class HealthKitTests: TestAppUITests {
    func testHealthKit() throws { // swiftlint:disable:this function_body_length
        let app = XCUIApplication()
        app.deleteAndLaunch(withSpringboardAppName: "TestApp")
        
        try exitAppAndOpenHealth(.electrocardiograms)
        try exitAppAndOpenHealth(.steps)
        try exitAppAndOpenHealth(.pushes)
        try exitAppAndOpenHealth(.restingHeartRate)
        try exitAppAndOpenHealth(.activeEnergy)
        
        app.activate()
        app.buttons["HealthKit"].tap()
        XCTAssert(app.buttons["Ask for authorization"].waitForExistence(timeout: 2))
        app.buttons["Ask for authorization"].tap()
        try app.handleHealthKitAuthorization()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .steps: 1
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .restingHeartRate: 1,
                .electrocardiograms: 1,
                .steps: 1,
                .pushes: 1
            ]
        )
        
        try exitAppAndOpenHealth(.electrocardiograms)
        app.activate()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .restingHeartRate: 1,
                .electrocardiograms: 2,
                .steps: 1,
                .pushes: 1
            ]
        )
        
        try exitAppAndOpenHealth(.steps)
        app.activate()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .restingHeartRate: 1,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 1
            ]
        )
        
        try exitAppAndOpenHealth(.pushes)
        app.activate()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .restingHeartRate: 1,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 2
            ]
        )
        
        try exitAppAndOpenHealth(.restingHeartRate)
        app.activate()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .restingHeartRate: 1,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 2
            ]
        )
        
        try exitAppAndOpenHealth(.activeEnergy)
        app.activate()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 2,
                .restingHeartRate: 1,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 2
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 2,
                .restingHeartRate: 2,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 2
            ]
        )
        
        // Relaunch App to test delivery after the app has been terminted.
        app.terminate()
        app.activate()
        XCTAssert(app.wait(for: .runningForeground, timeout: 10.0))
        app.buttons["HealthKit"].tap()
        app.buttons["Trigger data source collection"].tap()
        app.hkTypeIdentifierAssert([:])
        
        try exitAppAndOpenHealth(.electrocardiograms)
        try exitAppAndOpenHealth(.steps)
        try exitAppAndOpenHealth(.pushes)
        try exitAppAndOpenHealth(.restingHeartRate)
        try exitAppAndOpenHealth(.activeEnergy)
        app.activate()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .electrocardiograms: 1,
                .steps: 1,
                .pushes: 1
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        app.hkTypeIdentifierAssert(
            [
                .activeEnergy: 1,
                .restingHeartRate: 1,
                .electrocardiograms: 1,
                .steps: 1,
                .pushes: 1
            ]
        )
    }
}


extension XCUIApplication {
    fileprivate func hkTypeIdentifierAssert(_ hkTypeIdentifiers: [HealthAppDataType: Int]) {
        XCTAssert(wait(for: .runningForeground, timeout: 10.0))
        sleep(5)
        
        guard numberOfHKTypeIdentifiers() != hkTypeIdentifiers else {
            return
        }
        
        print("Wait 5 more seconds for HealthAppDataType to appear on screen ...")
        sleep(5)
        
        guard numberOfHKTypeIdentifiers() != hkTypeIdentifiers else {
            return
        }
        
        print("Wait 10 more seconds for HealthAppDataType to appear on screen ...")
        sleep(10)
        
        XCTAssertEqual(
            numberOfHKTypeIdentifiers(),
            hkTypeIdentifiers
        )
    }
    
    private func numberOfHKTypeIdentifiers() -> [HealthAppDataType: Int] {
        var observations: [HealthAppDataType: Int] = [:]
        for healthDataType in HealthAppDataType.allCases {
            let numberOfHKTypeNames = staticTexts
                .allElementsBoundByIndex
                .filter {
                    $0.label.contains(healthDataType.hkTypeName)
                }
                .count
            if numberOfHKTypeNames > 0 {
                observations[healthDataType] = numberOfHKTypeNames
            }
        }
        return observations
    }
}
