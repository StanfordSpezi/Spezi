//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import SwiftUI
import UserNotifications
import XCTest


private final class TestNotificationHandler: Module, NotificationHandler, NotificationTokenHandler {
    @Application(\.registerRemoteNotifications)
    var registerRemoteNotifications
    @Application(\.unregisterRemoteNotifications)
    var unregisterRemoteNotifications

    private let actionExpectation: XCTestExpectation
    private let incomingNotificationExpectation: XCTestExpectation
    private let remoteNotificationExpectation: XCTestExpectation
#if !os(macOS)
    private var backgroundFetchResult: BackgroundFetchResult = .noData
#endif

    var lastDeviceToken: Data?

    init(
        actionExpectation: XCTestExpectation = .init(),
        incomingNotificationExpectation: XCTestExpectation = .init(),
        remoteNotificationExpectation: XCTestExpectation = .init()
    ) {
        self.actionExpectation = actionExpectation
        self.incomingNotificationExpectation = incomingNotificationExpectation
        self.remoteNotificationExpectation = remoteNotificationExpectation
    }

#if !os(macOS)
    func setFetchResult(_ fetchResult: BackgroundFetchResult) {
        self.backgroundFetchResult = fetchResult
    }
#endif


    func receiveUpdatedDeviceToken(_ deviceToken: Data) {
        lastDeviceToken = deviceToken
    }

#if !os(tvOS)
    func handleNotificationAction(_ response: UNNotificationResponse) async {
        actionExpectation.fulfill()
    }
#endif

    func receiveIncomingNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions? {
        incomingNotificationExpectation.fulfill()
        return [.badge, .banner]
    }

#if !os(macOS)
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) async -> BackgroundFetchResult {
        remoteNotificationExpectation.fulfill()
        return backgroundFetchResult
    }
#else
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) {
        remoteNotificationExpectation.fulfill()
    }
#endif
}


private final class EmptyNotificationHandler: Module, NotificationHandler {}


private class TestNotificationApplicationDelegate: SpeziAppDelegate {
    private let injectedModule: TestNotificationHandler

    override var configuration: Configuration {
        Configuration {
            injectedModule
            EmptyNotificationHandler() // ensure default implementations don't interfere with the tests
        }
    }

    init(_ injectedModule: TestNotificationHandler) {
        self.injectedModule = injectedModule
    }
}


final class NotificationsTests: XCTestCase {
    @MainActor
    func testRegisterNotificationsSuccessful() async throws {
        let module = TestNotificationHandler()
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi // init spezi

        let action = module.registerRemoteNotifications
        
        let expectation = XCTestExpectation(description: "RegisterRemoteNotifications")
        var caught: Error?

        Task { // this task also runs on main actor
            do {
                try await action()
            } catch {
                caught = error
            }
            expectation.fulfill()
        }

        try await Task.sleep(for: .milliseconds(500)) // allow dispatch of Task above

        let data = try XCTUnwrap("Hello World".data(using: .utf8))

#if os(iOS) || os(visionOS) || os(tvOS)
        delegate.application(UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: data)
#elseif os(watchOS)
        delegate.application(WKApplication.shared(), didRegisterForRemoteNotificationsWithDeviceToken: data)
#elseif os(macOS)
        delegate.application(NSApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: data)
#endif

        try await Task.sleep(for: .milliseconds(500)) // allow dispatch of Task above

        wait(for: [expectation])
        XCTAssertNil(caught)
        XCTAssertEqual(module.lastDeviceToken, data)
    }

    @MainActor
    func testRegisterNotificationsErroneous() async throws {
        enum TestError: Error, Equatable {
            case testError
        }

        let module = TestNotificationHandler()
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi // init spezi

        let action = module.registerRemoteNotifications

        let expectation = XCTestExpectation(description: "RegisterRemoteNotifications")
        var caught: Error?

        Task { // this task also runs on main actor
            do {
                try await action()
            } catch {
                caught = error
            }
            expectation.fulfill()
        }

        try await Task.sleep(for: .milliseconds(500)) // allow dispatch of Task above

#if os(iOS) || os(visionOS) || os(tvOS)
        delegate.application(UIApplication.shared, didFailToRegisterForRemoteNotificationsWithError: TestError.testError)
#elseif os(watchOS)
        delegate.application(WKApplication.shared(), didFailToRegisterForRemoteNotificationsWithError: TestError.testError)
#elseif os(macOS)
        delegate.application(NSApplication.shared, didFailToRegisterForRemoteNotificationsWithError: TestError.testError)
#endif

        try await Task.sleep(for: .milliseconds(500)) // allow dispatch of Task above

        wait(for: [expectation])
        XCTAssertNil(module.lastDeviceToken)
        let receivedError = try XCTUnwrap(caught as? TestError)
        XCTAssertEqual(receivedError, TestError.testError)
    }

    @MainActor
    func testUnregisterNotifications() async throws {
        let module = TestNotificationHandler()
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi // init spezi

        let action = module.unregisterRemoteNotifications
        action()
    }

    @MainActor
    func testRemoteNotificationDeliveryNoData() async throws {
        let expectation = XCTestExpectation(description: "RemoteNotification")

        let module = TestNotificationHandler(remoteNotificationExpectation: expectation)
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi

#if os(iOS) || os(visionOS) || os(tvOS)
        let result = await delegate.application(UIApplication.shared, didReceiveRemoteNotification: [:])
#elseif os(watchOS)
        let result = await delegate.didReceiveRemoteNotification([:])
#elseif os(macOS)
        delegate.application(NSApplication.shared, didReceiveRemoteNotification: [:])
#endif

        wait(for: [expectation])
#if !os(macOS)
        XCTAssertEqual(result, .noData)
#endif
    }

    @MainActor
    func testRemoteNotificationDeliveryNewData() async throws {
        let expectation = XCTestExpectation(description: "RemoteNotification")

        let module = TestNotificationHandler(remoteNotificationExpectation: expectation)
#if !os(macOS)
        module.setFetchResult(.newData)
#endif

        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi

#if os(iOS) || os(visionOS) || os(tvOS)
        let result = await delegate.application(UIApplication.shared, didReceiveRemoteNotification: [:])
#elseif os(watchOS)
        let result = await delegate.didReceiveRemoteNotification([:])
#elseif os(macOS)
        delegate.application(NSApplication.shared, didReceiveRemoteNotification: [:])
#endif

        wait(for: [expectation])
#if !os(macOS)
        XCTAssertEqual(result, .newData)
#endif
    }

    @MainActor
    func testRemoteNotificationDeliveryFailed() async throws {
        let expectation = XCTestExpectation(description: "RemoteNotification")

        let module = TestNotificationHandler(remoteNotificationExpectation: expectation)
#if !os(macOS)
        module.setFetchResult(.failed)
#endif

        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi

#if os(iOS) || os(visionOS) || os(tvOS)
        let result = await delegate.application(UIApplication.shared, didReceiveRemoteNotification: [:])
#elseif os(watchOS)
        let result = await delegate.didReceiveRemoteNotification([:])
#elseif os(macOS)
        delegate.application(NSApplication.shared, didReceiveRemoteNotification: [:])
#endif

        wait(for: [expectation])
#if !os(macOS)
        XCTAssertEqual(result, .failed)
#endif
    }
}
