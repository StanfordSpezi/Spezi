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


final class FHIRMockDataStorageProviderTests: TestAppUITests {
    func testFHIRMockDataStorageProviderTests() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--fhirTests"]
        app.deleteAndLaunch(withSpringboardAppName: "TestApp")
        
        app.activate()
        app.buttons["FHIRMockDataStorageProvider"].tap()
        XCTAssert(app.buttons["Authorize"].waitForExistence(timeout: 2))
        app.buttons["Authorize"].tap()
        try app.handleHealthKitAuthorization()
        
        try assertObservationCellPresent(false)
        
        try exitAppAndOpenHealth(.steps)
        app.activate()
        
        sleep(5)
        
        try assertObservationCellPresent(true, pressIfPresent: true)
        try assertObservationCellPresent(true, pressIfPresent: false)
    }
    
    
    private func assertObservationCellPresent(_ shouldBePresent: Bool, pressIfPresent: Bool = true) throws {
        let app = XCUIApplication()
        
        let observationText = "/Observation/"
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", observationText)
        
        if shouldBePresent {
            XCTAssertTrue(app.staticTexts.containing(predicate).firstMatch.waitForExistence(timeout: 5))
            if pressIfPresent {
                app.staticTexts.containing(predicate).firstMatch.tap()
            }
        } else {
            XCTAssertFalse(app.staticTexts.containing(predicate).firstMatch.waitForExistence(timeout: 5))
        }
    }
}
