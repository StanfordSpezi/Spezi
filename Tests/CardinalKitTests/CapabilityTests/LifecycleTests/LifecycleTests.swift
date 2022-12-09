//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import XCTest
import XCTRuntimeAssertions


private final class TestLifecycleHandler: Component, LifecycleHandler, TypedCollectionKey {
    typealias ComponentStandard = MockStandard
    
    
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    init(expectationWillFinishLaunchingWithOption: XCTestExpectation, expectationApplicationWillTerminate: XCTestExpectation) {
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


private final class EmpfyLifecycleHandler: Component, LifecycleHandler, TypedCollectionKey {
    typealias ComponentStandard = MockStandard
}

private class TestLifecycleHandlerApplicationDelegate: CardinalKitAppDelegate {
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
    
    
    init(expectationWillFinishLaunchingWithOption: XCTestExpectation, expectationApplicationWillTerminate: XCTestExpectation) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
}


final class LifecycleTests: XCTestCase {
    func testUIApplicationLifecycleMethods() async throws {
        let expectationWillFinishLaunchingWithOption = XCTestExpectation(description: "WillFinishLaunchingWithOptions")
        let expectationApplicationWillTerminate = XCTestExpectation(description: "ApplicationWillTerminate")
        let testApplicationDelegate = await TestLifecycleHandlerApplicationDelegate(
            expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
            expectationApplicationWillTerminate: expectationApplicationWillTerminate
        )
        
        let willFinishLaunchingWithOptions = try await testApplicationDelegate.application(
            UIApplication.shared,
            willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: XCTUnwrap(URL(string: "cardinalkit.stanford.edu"))]
        )
        XCTAssertTrue(willFinishLaunchingWithOptions)
        
        wait(for: [expectationWillFinishLaunchingWithOption])
        
        await testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
        
        wait(for: [expectationApplicationWillTerminate])
    }
}
