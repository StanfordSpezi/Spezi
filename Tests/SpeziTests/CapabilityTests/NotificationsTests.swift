//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(UserNotifications)
@testable import Spezi
import SwiftUI
import Testing
import UserNotifications


@available(*, deprecated, message: "Forward decpreation warnings.")
private final class TestNotificationHandler: Module, NotificationHandler, NotificationTokenHandler {
    @Application(\.registerRemoteNotifications)
    var registerRemoteNotifications
    @Application(\.unregisterRemoteNotifications)
    var unregisterRemoteNotifications

    private let actionConfirmation: Confirmation?
    private let incomingNotificationConfirmation: Confirmation?
    private let remoteNotificationConfirmation: Confirmation?
#if !os(macOS)
    private var backgroundFetchResult: BackgroundFetchResult = .noData
#endif

    var lastDeviceToken: Data?

    init(
        actionConfirmation: Confirmation? = nil,
        incomingNotificationConfirmation: Confirmation? = nil,
        remoteNotificationConfirmation: Confirmation? = nil
    ) {
        self.actionConfirmation = actionConfirmation
        self.incomingNotificationConfirmation = incomingNotificationConfirmation
        self.remoteNotificationConfirmation = remoteNotificationConfirmation
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
        actionConfirmation?()
    }
#endif

    func receiveIncomingNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions? {
        incomingNotificationConfirmation?()
        return [.badge, .banner]
    }

#if !os(macOS)
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) async -> BackgroundFetchResult {
        remoteNotificationConfirmation?()
        return backgroundFetchResult
    }
#else
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) {
        remoteNotificationConfirmation?()
    }
#endif
}


private final class EmptyNotificationHandler: Module, NotificationHandler {}


@available(*, deprecated, message: "Forward depcreation warnings")
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


@Suite("Notifications")
struct NotificationsTests {
    @MainActor
    @Test("Register Notifications Successfully")
    @available(*, deprecated, message: "Forward deprecation warnings")
    func testRegisterNotificationsSuccessful() async throws {
        let module = TestNotificationHandler()
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi // init spezi

        let action = module.registerRemoteNotifications

        async let registration = action()
        try await Task.sleep(for: .milliseconds(750)) // allow dispatch of Task above

        let data = try #require("Hello World".data(using: .utf8))

#if os(iOS) || os(visionOS) || os(tvOS)
        delegate.application(UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: data)
#elseif os(watchOS)
        delegate.application(WKApplication.shared(), didRegisterForRemoteNotificationsWithDeviceToken: data)
#elseif os(macOS)
        delegate.application(NSApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: data)
#endif

        try await Task.sleep(for: .milliseconds(750)) // allow dispatch of Task above

        _ = try await registration
        #expect(module.lastDeviceToken == data)
    }

    @MainActor
    @Test("Register Notifications Erroneous")
    @available(*, deprecated, message: "Forward deprecation warnings")
    func testRegisterNotificationsErroneous() async throws {
        enum TestError: Error, Equatable {
            case testError
        }

        let module = TestNotificationHandler()
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi // init spezi

        let action = module.registerRemoteNotifications

        async let registration = action()

        try await Task.sleep(for: .milliseconds(500)) // allow dispatch of Task above

#if os(iOS) || os(visionOS) || os(tvOS)
        delegate.application(UIApplication.shared, didFailToRegisterForRemoteNotificationsWithError: TestError.testError)
#elseif os(watchOS)
        delegate.application(WKApplication.shared(), didFailToRegisterForRemoteNotificationsWithError: TestError.testError)
#elseif os(macOS)
        delegate.application(NSApplication.shared, didFailToRegisterForRemoteNotificationsWithError: TestError.testError)
#endif

        try await Task.sleep(for: .milliseconds(500)) // allow dispatch of Task above

        do {
            _ = try await registration
            Issue.record("Registration was successful")
        } catch {
            #expect(module.lastDeviceToken == nil)
            let receivedError = try #require(error as? TestError)
            #expect(receivedError == TestError.testError)
        }
    }

    @MainActor
    @Test("Unregister Notifications")
    @available(*, deprecated, message: "Forward deprecation warnings")
    func testUnregisterNotifications() async throws {
        let module = TestNotificationHandler()
        let delegate = TestNotificationApplicationDelegate(module)
        _ = delegate.spezi // init spezi

        let action = module.unregisterRemoteNotifications
        action()
    }

    @MainActor
    @Test("Remote Notification delivers no Data")
    @available(*, deprecated, message: "Forward deprecation warnings")
    func testRemoteNotificationDeliveryNoData() async {
        await confirmation { confirmation in
            let module = TestNotificationHandler(remoteNotificationConfirmation: confirmation)
            let delegate = TestNotificationApplicationDelegate(module)
            _ = delegate.spezi

#if os(iOS) || os(visionOS) || os(tvOS)
            let result = await delegate.application(UIApplication.shared, didReceiveRemoteNotification: [:])
#elseif os(watchOS)
            let result = await delegate.didReceiveRemoteNotification([:])
#elseif os(macOS)
            delegate.application(NSApplication.shared, didReceiveRemoteNotification: [:])
#endif

#if !os(macOS)
            #expect(result == .noData)
#endif
        }
    }

    @MainActor
    @Test("Remote Notifications delivers Data")
    @available(*, deprecated, message: "Forward deprecation warnings")
    func testRemoteNotificationDeliveryNewData() async throws {
        await confirmation { confirmation in
            let module = TestNotificationHandler(remoteNotificationConfirmation: confirmation)
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

#if !os(macOS)
            #expect(result == .newData)
#endif
        }
    }

    @MainActor
    @Test("Remote Notifications Delivery Failed")
    @available(*, deprecated, message: "Forward deprecation warnings")
    func testRemoteNotificationDeliveryFailed() async {
        await confirmation { confirmation in
            let module = TestNotificationHandler(remoteNotificationConfirmation: confirmation)
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

#if !os(macOS)
            #expect(result == .failed)
#endif
        }
    }
}
#endif
