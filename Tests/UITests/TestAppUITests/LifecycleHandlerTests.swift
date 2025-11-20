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
    @MainActor
    func testLifecycleHandler() throws {
        #if os(macOS) || os(watchOS)
            throw XCTSkip("LifecycleHandler is not supported on macOS or watchOS.")
        #endif

        let app = XCUIApplication()
        app.launchArguments = ["--lifecycleTests"]
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

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

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        XCTAssert(app.staticTexts["WillFinishLaunchingWithOptions: 1"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillEnterForeground: 2"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneDidBecomeActive: 2"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["SceneWillResignActive: 1"].exists)
        XCTAssert(app.staticTexts["SceneDidEnterBackground: 1"].exists)
        XCTAssert(app.staticTexts["ApplicationWillTerminate: 0"].exists)
    }

    @MainActor
    func testServiceModule() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--lifecycleTests"]
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        XCTAssertTrue(app.staticTexts["Module is running."].waitForExistence(timeout: 15.0))

        let springboard = XCUIApplication(bundleIdentifier: XCUIApplication.homeScreenBundle)
#if os(visionOS)
        springboard.launch() // springboard is in `runningBackgroundSuspended` state on visionOS. So we need to launch it not just activate
#else
        springboard.activate()
#endif

        XCTAssertTrue(springboard.wait(for: .runningForeground, timeout: 15.0))

        app.activate()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))
        XCTAssertTrue(app.staticTexts["Module is running."].waitForExistence(timeout: 10.0))

#if os(visionOS)
        springboard.launch() // springboard is in `runningBackgroundSuspended` state on visionOS. So we need to launch it not just activate
#else
        springboard.activate()
#endif
        XCTAssertTrue(springboard.wait(for: .runningForeground, timeout: 5.0))

        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))
        XCTAssertTrue(app.staticTexts["Module is running."].waitForExistence(timeout: 2.0))
    }
}
