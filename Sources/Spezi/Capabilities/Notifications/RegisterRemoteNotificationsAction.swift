//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import SwiftUI


@MainActor
private final class RemoteNotificationContinuation: KnowledgeSource, Sendable {
    typealias Anchor = SpeziAnchor

    fileprivate(set) var continuation: CheckedContinuation<Data, Error>?
    fileprivate(set) var access = AsyncSemaphore()


    init() {}


    @MainActor
    func resume(with result: Result<Data, Error>) {
        if let continuation {
            self.continuation = nil
            access.signal()
            continuation.resume(with: result)
        }
    }
}


/// Registers to receive remote notifications through Apple Push Notification service.
///
/// For more information refer to the [`registerForRemoteNotifications()`](https://developer.apple.com/documentation/uikit/uiapplication/1623078-registerforremotenotifications)
/// documentation for `UIApplication` or for the respective equivalent for your current platform.
///
/// - Note: For more information on the general topic on how to register your app with APNs,
///     refer to the [Registering your app with APNs](https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns)
///     article.
/// > Tip: Make sure to request authorization by calling [`requestAuthorization(options:completionHandler:)`](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/requestauthorization(options:completionhandler:))
///     to have your remote notifications be able to display alerts, badges or use sound. Otherwise, all remote notifications will be delivered silently.
///
/// Below is a short code example on how to use this action within your ``Module``.
/// ```swift
/// class ExampleModule: Module {
///     @Application(\.registerRemoteNotifications)
///     var registerRemoteNotifications
///
///     func handleNotificationsPermissions() async throws {
///         // Make sure to request notifications permissions before registering for remote notifications
///         try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
///         let deviceToken = try await registerRemoteNotifications()
///
///         // ... send the device token to your remote server that generates push notifications
///     }
/// }
/// ```
///
/// > Warning: The method might throw a [`TimeoutError`](https://swiftpackageindex.com/stanfordspezi/spezifoundation/documentation/spezifoundation/timeouterror)
/// if registering for remote notifications is not possible.
///
/// Registering for Remote Notifications on Simulator devices might not be possible due to multiple reasons.
///
/// #### Your application delegate, which is a subclass of SpeziAppDelegate, overrides some notification-related application delegate functions.
///
/// **Solution:** Ensure that you correctly call the overridden method using super to pass all relevant information to Spezi.
///
/// #### Your application does not have the correct entitlements and configuration in place to allow registering for remote notifications.
///
/// **Solution:** Follow the [Apple Documentation](https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns).
///
/// #### Your code or a dependency uses method swizzling, preventing the relevant methods in the application delegate from being called.
///
/// **Solution:** Remove your method swizzling code or configure your dependency to disable this behavior.
/// For example, to [disable method swizzling in the iOS Firebase SDK](https://firebase.google.com/docs/cloud-messaging/ios/client#method_swizzling_in).
///
/// #### The application is running in the iOS simulator on a Mac that is not signed into an Apple account (e.g., on a CI environment).
/// **Solution:** Sign in with an Apple account on your Mac and Xcode. For CI environments, use a special flag or compilation directive to catch the `TimeoutError`.
public struct RegisterRemoteNotificationsAction: Sendable {
    private weak var spezi: Spezi?

    init(_ spezi: Spezi) {
        self.spezi = spezi
    }

    /// Registers to receive remote notifications through Apple Push Notification service.
    ///
    /// - Returns: A globally unique token that identifies this device to APNs.
    ///     Send this token to the server that you use to generate remote notifications.
    ///     Your server must pass this token unmodified back to APNs when sending those remote notifications.
    ///     For more information refer to the documentation of
    ///     [`application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622958-application).
    /// - Throws: Registration might fail if the user's device isn't connected to the network or
    ///     if your app is not properly configured for remote notifications. It might also throw a `TimeoutError` when running on a simulator device running on a host
    ///     that is not connected to an Apple ID.
    @discardableResult
    @MainActor
    public func callAsFunction() async throws -> Data {
        guard let spezi else {
            preconditionFailure("RegisterRemoteNotificationsAction was used in a scope where Spezi was not available anymore!")
        }


#if os(watchOS)
        let application = _Application.shared()
#else
        let application = _Application.shared
#endif // os(watchOS)

        let registration: RemoteNotificationContinuation
        if let existing = spezi.storage[RemoteNotificationContinuation.self] {
            registration = existing
        } else {
            registration = RemoteNotificationContinuation()
            spezi.storage[RemoteNotificationContinuation.self] = registration
        }

        try await registration.access.waitCheckingCancellation()

        async let _ = withTimeout(of: .seconds(5)) { @MainActor in
            spezi.logger.warning(
                """
                Registering for Remote Notifications Timed Out

                This issue can occur for several reasons:

                - Your application delegate (subclass of `SpeziAppDelegate`) overrides some notification-related application delegate functions.
                  Solution: Ensure that you correctly call the overridden method using `super` to pass all relevant information to Spezi.
                
                - Your application does not have the correct entitlements and configuration in place to allow registering for remote notifications.
                  Solution: Follow the Apple Documentation at https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns.

                - Your code or a dependency uses method swizzling, preventing the relevant methods in the application delegate from being called.
                  Solution: Remove your method swizzling code or configure your dependency to disable this behavior.
                            For example, to disable method swizzling in the iOS Firebase SDK, follow their guidelines at
                            https://firebase.google.com/docs/cloud-messaging/ios/client#method_swizzling_in.

                - The application is running in the iOS simulator on a Mac that is not signed into an Apple account (e.g., on a CI environment).
                  Solution: Sign in with an Apple account on your Mac and Xcode.
                            For CI environments, use a special flag or compilation directive to catch the `TimeoutError`.
                """
            )
            spezi.storage[RemoteNotificationContinuation.self]?.resume(with: .failure(TimeoutError()))
        }

        return try await withCheckedThrowingContinuation { continuation in
            assert(registration.continuation == nil, "continuation wasn't nil")
            registration.continuation = continuation
            application.registerForRemoteNotifications()
        }
    }
}


extension Spezi {
    /// Registers to receive remote notifications through Apple Push Notification service.
    ///
    /// For more information refer to the [`registerForRemoteNotifications()`](https://developer.apple.com/documentation/uikit/uiapplication/1623078-registerforremotenotifications)
    /// documentation for `UIApplication` or for the respective equivalent for your current platform.
    ///
    /// - Note: For more information on the general topic on how to register your app with APNs,
    ///     refer to the [Registering your app with APNs](https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns)
    ///     article.
    /// > Tip: Make sure to request authorization by calling [`requestAuthorization(options:completionHandler:)`](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/requestauthorization(options:completionhandler:))
    ///     to have your remote notifications be able to display alerts, badges or use sound. Otherwise, all remote notifications will be delivered silently.
    ///
    /// Below is a short code example on how to use this action within your ``Module``.
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.registerRemoteNotifications)
    ///     var registerRemoteNotifications
    ///
    ///     func handleNotificationsPermissions() async throws {
    ///         // Make sure to request notifications permissions before registering for remote notifications
    ///         try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    ///         let deviceToken = try await registerRemoteNotifications()
    ///
    ///         // ... send the device token to your remote server that generates push notifications
    ///     }
    /// }
    /// ```
    ///
    /// > Warning: The method might throw a [`TimeoutError`](https://swiftpackageindex.com/stanfordspezi/spezifoundation/documentation/spezifoundation/timeouterror)
    /// if registering for remote notifications is not possible.
    ///
    /// Registering for Remote Notifications on Simulator devices might not be possible due to multiple reasons.
    ///
    /// #### Your application delegate, which is a subclass of SpeziAppDelegate, overrides some notification-related application delegate functions.
    ///
    /// **Solution:** Ensure that you correctly call the overridden method using super to pass all relevant information to Spezi.
    ///
    /// #### Your application does not have the correct entitlements and configuration in place to allow registering for remote notifications.
    ///
    /// **Solution:** Follow the [Apple Documentation](https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns).
    ///
    /// #### Your code or a dependency uses method swizzling, preventing the relevant methods in the application delegate from being called.
    ///
    /// **Solution:** Remove your method swizzling code or configure your dependency to disable this behavior.
    /// For example, to [disable method swizzling in the iOS Firebase SDK](https://firebase.google.com/docs/cloud-messaging/ios/client#method_swizzling_in).
    ///
    /// #### The application is running in the iOS simulator on a Mac that is not signed into an Apple account (e.g., on a CI environment).
    /// **Solution:** Sign in with an Apple account on your Mac and Xcode. For CI environments, use a special flag or compilation directive to catch the `TimeoutError`.
    ///
    ///
    /// ## Topics
    /// ### Action
    /// - ``RegisterRemoteNotificationsAction``
    public var registerRemoteNotifications: RegisterRemoteNotificationsAction {
        RegisterRemoteNotificationsAction(self)
    }
}


extension RegisterRemoteNotificationsAction {
    @MainActor
    static func handleDeviceTokenUpdate(_ spezi: Spezi, _ deviceToken: Data) {
        guard let registration = spezi.storage[RemoteNotificationContinuation.self] else {
            return
        }

        // might also be called if, e.g., app is restored from backup and is automatically registered for remote notifications.
        // This can be handled through the `NotificationHandler` protocol.

        registration.resume(with: .success(deviceToken))
    }

    @MainActor
    static func handleFailedRegistration(_ spezi: Spezi, _ error: Error) {
        guard let registration = spezi.storage[RemoteNotificationContinuation.self] else {
            return
        }

        if registration.continuation == nil {
            spezi.logger.warning("Received a call to \(#function) while we were not waiting for a notifications registration request.")
        }

        registration.resume(with: .failure(error))
    }
}
