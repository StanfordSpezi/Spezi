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


private final class TestLifecycleHandler: Module, LifecycleHandler {
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    init(
        expectationWillFinishLaunchingWithOption: XCTestExpectation,
        expectationApplicationWillTerminate: XCTestExpectation
    ) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
    
    
    func willFinishLaunchingWithOptions(
        launchOptions: [LaunchOptionsKey: Any]
    ) {
        expectationWillFinishLaunchingWithOption.fulfill()
    }
    
    func applicationWillTerminate() {
        expectationApplicationWillTerminate.fulfill()
    }
}


private final class EmptyLifecycleHandler: Module, LifecycleHandler { }

private class TestLifecycleHandlerApplicationDelegate: SpeziAppDelegate {
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    override var configuration: Configuration {
        Configuration {
            TestLifecycleHandler(
                expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
                expectationApplicationWillTerminate: expectationApplicationWillTerminate
            )
            EmptyLifecycleHandler()
        }
    }
    
    
    init(
        expectationWillFinishLaunchingWithOption: XCTestExpectation,
        expectationApplicationWillTerminate: XCTestExpectation
    ) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
}


final class LifecycleTests: XCTestCase {
    @MainActor
    func testUIApplicationLifecycleMethods() async throws {
        let expectationWillFinishLaunchingWithOption = XCTestExpectation(description: "WillFinishLaunchingWithOptions")
        let expectationApplicationWillTerminate = XCTestExpectation(description: "ApplicationWillTerminate")
        
        let testApplicationDelegate = TestLifecycleHandlerApplicationDelegate(
            expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
            expectationApplicationWillTerminate: expectationApplicationWillTerminate
        )


        #if os(iOS) || os(visionOS) || os(tvOS)
        let willFinishLaunchingWithOptions = try testApplicationDelegate.application(
            UIApplication.shared,
            willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: XCTUnwrap(URL(string: "spezi.stanford.edu"))]
        )
        XCTAssertTrue(willFinishLaunchingWithOptions)
        #elseif os(macOS)
        testApplicationDelegate.applicationWillFinishLaunching(Notification(name: NSApplication.willFinishLaunchingNotification))
        #elseif os(watchOS)
        testApplicationDelegate.applicationDidFinishLaunching()
        #endif
        wait(for: [expectationWillFinishLaunchingWithOption])
        
        #if os(iOS) || os(visionOS) || os(tvOS)
        testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
        wait(for: [expectationApplicationWillTerminate])
        #elseif os(macOS)
        testApplicationDelegate.applicationWillTerminate(.init(name: NSApplication.willTerminateNotification))
        wait(for: [expectationApplicationWillTerminate])
        #endif
    }
}
