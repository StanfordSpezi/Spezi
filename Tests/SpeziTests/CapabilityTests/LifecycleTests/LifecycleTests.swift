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


@available(*, deprecated, message: "Propagate deprecation warning")
private final class TestLifecycleHandler: Module, LifecycleHandler {
    let expectationWillFinishLaunchingWithOption: XCTestExpectation
    let expectationApplicationWillTerminate: XCTestExpectation

    @Application(\.launchOptions)
    var launchOptions

    
    init(
        expectationWillFinishLaunchingWithOption: XCTestExpectation,
        expectationApplicationWillTerminate: XCTestExpectation
    ) {
        self.expectationWillFinishLaunchingWithOption = expectationWillFinishLaunchingWithOption
        self.expectationApplicationWillTerminate = expectationApplicationWillTerminate
    }
    
#if os(iOS) || os(visionOS) || os(tvOS)
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        expectationWillFinishLaunchingWithOption.fulfill()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        expectationApplicationWillTerminate.fulfill()
    }
#endif
}


@available(*, deprecated, message: "Propagate deprecation warning")
private final class EmptyLifecycleHandler: Module, LifecycleHandler { }

@available(*, deprecated, message: "Propagate deprecation warning")
private class TestLifecycleHandlerApplicationDelegate: SpeziAppDelegate {
    private let injectedModule: TestLifecycleHandler
    
    
    override var configuration: Configuration {
        Configuration {
            injectedModule
            EmptyLifecycleHandler()
        }
    }

    init(injectedModule: TestLifecycleHandler) {
        self.injectedModule = injectedModule
    }
}


final class LifecycleTests: XCTestCase {
    @MainActor
    @available(*, deprecated, message: "Propagate deprecation warning")
    func testUIApplicationLifecycleMethods() async throws {
        let expectationWillFinishLaunchingWithOption = XCTestExpectation(description: "WillFinishLaunchingWithOptions")
        let expectationApplicationWillTerminate = XCTestExpectation(description: "ApplicationWillTerminate")

        let module = TestLifecycleHandler(
            expectationWillFinishLaunchingWithOption: expectationWillFinishLaunchingWithOption,
            expectationApplicationWillTerminate: expectationApplicationWillTerminate
        )
        let testApplicationDelegate = TestLifecycleHandlerApplicationDelegate(injectedModule: module)


        #if os(iOS) || os(visionOS) || os(tvOS)
        let launchOptions = try [UIApplication.LaunchOptionsKey.url: XCTUnwrap(URL(string: "spezi.stanford.edu"))]
        let willFinishLaunchingWithOptions = testApplicationDelegate.application(
            UIApplication.shared,
            willFinishLaunchingWithOptions: launchOptions
        )
        XCTAssertTrue(willFinishLaunchingWithOptions)
        wait(for: [expectationWillFinishLaunchingWithOption])

        XCTAssertTrue(module.launchOptions.keys.allSatisfy { launchOptions[$0] != nil })
        #elseif os(macOS)
        let launchOptions: [AnyHashable: Any] = [UUID(): "Some value"]
        testApplicationDelegate.applicationWillFinishLaunching(
            Notification(name: NSApplication.willFinishLaunchingNotification, userInfo: launchOptions)
        )

        XCTAssertTrue(module.launchOptions.keys.allSatisfy { launchOptions[$0] != nil })
        #elseif os(watchOS)
        testApplicationDelegate.applicationDidFinishLaunching()
        #endif

        #if os(iOS) || os(visionOS) || os(tvOS)
        testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
        wait(for: [expectationApplicationWillTerminate])
        #endif
    }
}
