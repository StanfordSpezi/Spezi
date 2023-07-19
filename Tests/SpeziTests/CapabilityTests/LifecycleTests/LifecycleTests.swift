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


private final class TestLifecycleHandler: Component, LifecycleHandler {
    typealias ComponentStandard = MockStandard
    
    
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
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        expectationWillFinishLaunchingWithOption.fulfill()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        expectationApplicationWillTerminate.fulfill()
    }
}


private final class EmpfyLifecycleHandler: Component, LifecycleHandler {
    typealias ComponentStandard = MockStandard
}

private class TestLifecycleHandlerApplicationDelegate: SpeziAppDelegate {
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    override var configuration: Configuration {
        Configuration(standard: MockStandard()) {
            TestLifecycleHandler(
                expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
                expectationApplicationWillTerminate: expectationApplicationWillTerminate
            )
            EmpfyLifecycleHandler()
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
        
        let willFinishLaunchingWithOptions = try testApplicationDelegate.application(
            UIApplication.shared,
            willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: XCTUnwrap(URL(string: "spezi.stanford.edu"))]
        )
        XCTAssertTrue(willFinishLaunchingWithOptions)
        wait(for: [expectationWillFinishLaunchingWithOption])
        
        testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
        wait(for: [expectationApplicationWillTerminate])
    }
}
