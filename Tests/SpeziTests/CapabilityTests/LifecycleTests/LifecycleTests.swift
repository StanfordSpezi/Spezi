//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import XCTest
import XCTRuntimeAssertions


// We disable long identifier names as we want the expectations to be fully expressive.
// swiftlint:disable identifier_name
private final class TestLifecycleHandler: Component, LifecycleHandler, TypedCollectionKey {
    typealias ComponentStandard = MockStandard
    
    
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationDidBecomeActive: XCTestExpectation
    let expectationApplicationWillResignActive: XCTestExpectation
    let expectationApplicationDidEnterBackground: XCTestExpectation
    let expectationApplicationWillEnterForeground: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    init(
        expectationWillFinishLaunchingWithOption: XCTestExpectation,
        expectationApplicationDidBecomeActive: XCTestExpectation,
        expectationApplicationWillResignActive: XCTestExpectation,
        expectationApplicationDidEnterBackground: XCTestExpectation,
        expectationApplicationWillEnterForeground: XCTestExpectation,
        expectationApplicationWillTerminate: XCTestExpectation
    ) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationDidBecomeActive = expectationApplicationDidBecomeActive
        self.expectationApplicationWillResignActive = expectationApplicationWillResignActive
        self.expectationApplicationDidEnterBackground = expectationApplicationDidEnterBackground
        self.expectationApplicationWillEnterForeground = expectationApplicationWillEnterForeground
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
    
    
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        expectationWillFinishLaunchingWithOption.fulfill()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        expectationApplicationDidBecomeActive.fulfill()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        expectationApplicationWillResignActive.fulfill()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        expectationApplicationDidEnterBackground.fulfill()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        expectationApplicationWillEnterForeground.fulfill()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        expectationApplicationWillTerminate.fulfill()
    }
}


private final class EmpfyLifecycleHandler: Component, LifecycleHandler, TypedCollectionKey {
    typealias ComponentStandard = MockStandard
}

private class TestLifecycleHandlerApplicationDelegate: SpeziAppDelegate {
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationDidBecomeActive: XCTestExpectation
    let expectationApplicationWillResignActive: XCTestExpectation
    let expectationApplicationDidEnterBackground: XCTestExpectation
    let expectationApplicationWillEnterForeground: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    override var configuration: Configuration {
        Configuration(standard: MockStandard()) {
            TestLifecycleHandler(
                expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
                expectationApplicationDidBecomeActive: expectationApplicationDidBecomeActive,
                expectationApplicationWillResignActive: expectationApplicationWillResignActive,
                expectationApplicationDidEnterBackground: expectationApplicationDidEnterBackground,
                expectationApplicationWillEnterForeground: expectationApplicationWillEnterForeground,
                expectationApplicationWillTerminate: expectationApplicationWillTerminate
            )
            EmpfyLifecycleHandler()
        }
    }
    
    
    init(
        expectationWillFinishLaunchingWithOption: XCTestExpectation,
        expectationApplicationDidBecomeActive: XCTestExpectation,
        expectationApplicationWillResignActive: XCTestExpectation,
        expectationApplicationDidEnterBackground: XCTestExpectation,
        expectationApplicationWillEnterForeground: XCTestExpectation,
        expectationApplicationWillTerminate: XCTestExpectation
    ) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationDidBecomeActive = expectationApplicationDidBecomeActive
        self.expectationApplicationWillResignActive = expectationApplicationWillResignActive
        self.expectationApplicationDidEnterBackground = expectationApplicationDidEnterBackground
        self.expectationApplicationWillEnterForeground = expectationApplicationWillEnterForeground
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
}


final class LifecycleTests: XCTestCase {
    func testUIApplicationLifecycleMethods() async throws {
        let expectationWillFinishLaunchingWithOption = XCTestExpectation(description: "WillFinishLaunchingWithOptions")
        let expectationApplicationDidBecomeActive = XCTestExpectation(description: "ApplicationDidBecomeActive")
        let expectationApplicationWillResignActive = XCTestExpectation(description: "ApplicationWillResignActive")
        let expectationApplicationDidEnterBackground = XCTestExpectation(description: "ApplicationDidEnterBackground")
        let expectationApplicationWillEnterForeground = XCTestExpectation(description: "ApplicationWillEnterForeground")
        let expectationApplicationWillTerminate = XCTestExpectation(description: "ApplicationWillTerminate")
        
        let testApplicationDelegate = await TestLifecycleHandlerApplicationDelegate(
            expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
            expectationApplicationDidBecomeActive: expectationApplicationDidBecomeActive,
            expectationApplicationWillResignActive: expectationApplicationWillResignActive,
            expectationApplicationDidEnterBackground: expectationApplicationDidEnterBackground,
            expectationApplicationWillEnterForeground: expectationApplicationWillEnterForeground,
            expectationApplicationWillTerminate: expectationApplicationWillTerminate
        )
        
        let willFinishLaunchingWithOptions = try await testApplicationDelegate.application(
            UIApplication.shared,
            willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: XCTUnwrap(URL(string: "spezi.stanford.edu"))]
        )
        XCTAssertTrue(willFinishLaunchingWithOptions)
        wait(for: [expectationWillFinishLaunchingWithOption])
        
        await testApplicationDelegate.applicationDidBecomeActive(UIApplication.shared)
        wait(for: [expectationApplicationDidBecomeActive])
        
        await testApplicationDelegate.applicationWillResignActive(UIApplication.shared)
        wait(for: [expectationApplicationWillResignActive])
        
        await testApplicationDelegate.applicationDidEnterBackground(UIApplication.shared)
        wait(for: [expectationApplicationDidEnterBackground])
        
        await testApplicationDelegate.applicationWillEnterForeground(UIApplication.shared)
        wait(for: [expectationApplicationWillEnterForeground])
        
        await testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
        wait(for: [expectationApplicationWillTerminate])
    }
}
