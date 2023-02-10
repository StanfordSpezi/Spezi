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
        try exitAppAndOpenHealth(.electrocardiograms)
        try exitAppAndOpenHealth(.steps)
        try exitAppAndOpenHealth(.pushes)
        try exitAppAndOpenHealth(.restingHeartRate)
        try exitAppAndOpenHealth(.activeEnergy)
        
        let app = XCUIApplication()
        app.deleteAndLaunch(withSpringboardAppName: "TestApp")
        
        app.buttons["HealthKit"].tap()
        
        XCTAssert(app.buttons["Ask for authorization"].waitForExistence(timeout: 2))
        app.buttons["Ask for authorization"].tap()
        
        try app.handleHealthKitAuthorization()
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 1,
                HealthAppDataType.steps.hkTypeName: 1,
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 1,
                HealthAppDataType.restingHeartRate.hkTypeName: 1,
                HealthAppDataType.electrocardiograms.hkTypeName: 1,
                HealthAppDataType.steps.hkTypeName: 1,
                HealthAppDataType.pushes.hkTypeName: 1
            ]
        )
        
        try exitAppAndOpenHealth(.electrocardiograms)
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 1,
                HealthAppDataType.restingHeartRate.hkTypeName: 1,
                HealthAppDataType.electrocardiograms.hkTypeName: 2,
                HealthAppDataType.steps.hkTypeName: 1,
                HealthAppDataType.pushes.hkTypeName: 1
            ]
        )
        
        try exitAppAndOpenHealth(.steps)
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 1,
                HealthAppDataType.restingHeartRate.hkTypeName: 1,
                HealthAppDataType.electrocardiograms.hkTypeName: 2,
                HealthAppDataType.steps.hkTypeName: 2,
                HealthAppDataType.pushes.hkTypeName: 1
            ]
        )
        
        try exitAppAndOpenHealth(.pushes)
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 1,
                HealthAppDataType.restingHeartRate.hkTypeName: 1,
                HealthAppDataType.electrocardiograms.hkTypeName: 2,
                HealthAppDataType.steps.hkTypeName: 2,
                HealthAppDataType.pushes.hkTypeName: 2
            ]
        )
        
        try exitAppAndOpenHealth(.restingHeartRate)
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 1,
                HealthAppDataType.restingHeartRate.hkTypeName: 1,
                HealthAppDataType.electrocardiograms.hkTypeName: 2,
                HealthAppDataType.steps.hkTypeName: 2,
                HealthAppDataType.pushes.hkTypeName: 2
            ]
        )

        try exitAppAndOpenHealth(.activeEnergy)
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 2,
                HealthAppDataType.restingHeartRate.hkTypeName: 1,
                HealthAppDataType.electrocardiograms.hkTypeName: 2,
                HealthAppDataType.steps.hkTypeName: 2,
                HealthAppDataType.pushes.hkTypeName: 2
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                HealthAppDataType.activeEnergy.hkTypeName: 2,
                HealthAppDataType.restingHeartRate.hkTypeName: 2,
                HealthAppDataType.electrocardiograms.hkTypeName: 2,
                HealthAppDataType.steps.hkTypeName: 2,
                HealthAppDataType.pushes.hkTypeName: 2
            ]
        )
    }
}
