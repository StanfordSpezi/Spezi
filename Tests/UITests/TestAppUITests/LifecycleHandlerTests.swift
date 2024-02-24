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
        #if os(macOS) || os(watchOS)
            throw XCTSkip("LifecycleHandler is not supported on macOS or watchOS.")
        #endif

        let app = XCUIApplication()
        app.launchArguments = ["--lifecycleTests"]
        app.launch()

        app.buttons["LifecycleHandler"].tap()

        XCTAssert(app.staticTexts["WillFinishLaunchingWithOptions: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillEnterForeground: 1"].exists)
        XCTAssert(app.staticTexts["SceneDidBecomeActive: 1"].exists)
        XCTAssert(app.staticTexts["SceneWillResignActive: 0"].exists)
        XCTAssert(app.staticTexts["SceneDidEnterBackground: 0"].exists)
        XCTAssert(app.staticTexts["ApplicationWillTerminate: 0"].exists)


        #if os(visionOS)
        let chrome = XCUIApplication(bundleIdentifier: "com.apple.RealityChrome")
        XCTAssert(chrome.buttons["CloseButton"].exists)
        chrome.buttons["CloseButton"].tap()
        sleep(3)
        app.activate()
        #elseif !os(macOS)
        let homeScreen = XCUIApplication(bundleIdentifier: XCUIApplication.homeScreenBundle)
        homeScreen.activate()
        app.activate()
        #endif

        XCTAssert(app.staticTexts["WillFinishLaunchingWithOptions: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillEnterForeground: 2"].exists)
        XCTAssert(app.staticTexts["SceneDidBecomeActive: 2"].exists)
        XCTAssert(app.staticTexts["SceneWillResignActive: 1"].exists)
        XCTAssert(app.staticTexts["SceneDidEnterBackground: 1"].exists)
        XCTAssert(app.staticTexts["ApplicationWillTerminate: 0"].exists)
    }
}
