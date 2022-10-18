//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import XCTest


private class TestLifecycleHandler: LifecycleHandler, StorageKey {
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation
    
    
    init(expectationWillFinishLaunchingWithOption: XCTestExpectation, expectationApplicationWillTerminate: XCTestExpectation) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
    
    
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any],
        cardinalKit: CardinalKit
    ) {
        expectationWillFinishLaunchingWithOption.fulfill()
    }
    
    func applicationWillTerminate(_ application: UIApplication, cardinalKit: CardinalKit) {
        expectationApplicationWillTerminate.fulfill()
    }
}

private class EmpfyLifecycleHandler: LifecycleHandler, StorageKey {}


extension CardinalKit { // swiftlint:disable:this file_types_order
    fileprivate var testLifecycleHandler: TestLifecycleHandler? {
        get async {
            await storage.get(TestLifecycleHandler.self)
        }
    }
    
    
    fileprivate func setTestLifecycleHandler(_ testLifecycleHandler: TestLifecycleHandler) async {
        await storage.set(TestLifecycleHandler.self, to: testLifecycleHandler)
    }
    
    fileprivate func setEmptyLifecycleHandler(_ emptyLifecycleHandler: EmpfyLifecycleHandler) async {
        await storage.set(EmpfyLifecycleHandler.self, to: emptyLifecycleHandler)
    }
}


final class LifecycleTests: XCTestCase {
    class TestApplicationDelegate: CardinalKitAppDelegate {}
    
    
    func testUIApplicationLifecycleMethods() async throws {
        let testApplicationDelegate = await TestApplicationDelegate()
        let cardinalKit = await testApplicationDelegate.cardinalKit
        
        let expectationWillFinishLaunchingWithOption = XCTestExpectation(description: "WillFinishLaunchingWithOptions")
        let expectationApplicationWillTerminate = XCTestExpectation(description: "ApplicationWillTerminate")
        let testLifecycleHandler = TestLifecycleHandler(
            expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
            expectationApplicationWillTerminate: expectationApplicationWillTerminate
        )
        
        await cardinalKit.setTestLifecycleHandler(testLifecycleHandler)
        await cardinalKit.setEmptyLifecycleHandler(EmpfyLifecycleHandler())
        
        let willFinishLaunchingWithOptions = try await testApplicationDelegate.application(
            UIApplication.shared,
            willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: XCTUnwrap(URL(string: "cardinalkit.stanford.edu"))]
        )
        XCTAssertTrue(willFinishLaunchingWithOptions)
        
        wait(for: [expectationWillFinishLaunchingWithOption], timeout: 0.1)
        
        await testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
        
        wait(for: [expectationApplicationWillTerminate], timeout: 0.1)
    }
}
