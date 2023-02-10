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
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                .activeEnergy: 1,
                .steps: 1
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
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
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
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
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
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
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
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
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
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
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                .activeEnergy: 2,
                .restingHeartRate: 1,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 2
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                .activeEnergy: 2,
                .restingHeartRate: 2,
                .electrocardiograms: 2,
                .steps: 2,
                .pushes: 2
            ]
        )
        
        app.terminate()
        app.activate()
        
        app.buttons["HealthKit"].tap()
        app.buttons["Trigger data source collection"].tap()
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [:]
        )
        
        try exitAppAndOpenHealth(.electrocardiograms)
        try exitAppAndOpenHealth(.steps)
        try exitAppAndOpenHealth(.pushes)
        try exitAppAndOpenHealth(.restingHeartRate)
        try exitAppAndOpenHealth(.activeEnergy)
        
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
            [
                .activeEnergy: 1,
                .electrocardiograms: 1,
                .steps: 1,
                .pushes: 1
            ]
        )
        
        app.buttons["Trigger data source collection"].tap()
        app.activate()
        sleep(2)
        
        XCTAssertEqual(
            app.numberOfHKTypeIdentifiers(),
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
