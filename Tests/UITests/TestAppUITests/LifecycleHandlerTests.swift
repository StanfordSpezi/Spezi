//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


final class LifecycleHandlerTests: XCTestCase {
    func testLifecycleHandler() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--lifecycleTests"]
        app.deleteAndLaunch(withSpringboardAppName: "TestApp")
        
        app.staticTexts["LifecycleHandler"].tap()
        
        XCTAssert(app.staticTexts["WillFinishLaunchingWithOptions: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillEnterForeground: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneDidBecomeActive: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillResignActive: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneDidEnterBackground: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["ApplicationWillTerminate: 0"].waitForExistence(timeout: 2))
        
        
        let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springBoard.activate()
        app.activate()
        
        XCTAssert(app.staticTexts["WillFinishLaunchingWithOptions: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillEnterForeground: 2"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneDidBecomeActive: 2"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillResignActive: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneDidEnterBackground: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["ApplicationWillTerminate: 0"].waitForExistence(timeout: 2))
    }
}
