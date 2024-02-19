//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import SwiftUI


private class RemoteNotificationContinuation: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor

    static let defaultValue = RemoteNotificationContinuation()

    @MainActor
    var continuation: CheckedContinuation<Data, Error>?

    init() {}
}


/// Registers to receive remote notifications through Apple Push Notification service.
///
/// For more information refer to the [`registerForRemoteNotifications()`](https://developer.apple.com/documentation/uikit/uiapplication/1623078-registerforremotenotifications)
/// documentation for `UIApplication` or for the respective equivalent for your current platform.
///
/// - Note: For more information on the general topic on how to register your app with APNs,
///     refer to the [Registering your app with APNs](https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns)
///     article.
///
/// Below is a short code example on how to use this action within your ``Module``.
///
/// ```swift
/// class ExampleModule: Module {
///     @Application(\.registerRemoteNotifications)
///     var registerRemoteNotifications
///
///     func handleNotificationsAllowed() async throws {
///         let deviceToken = try await registerRemoteNotifications()
///         // .. send the device token to your remote server that generates push notifications
///     }
/// }
/// ```
public struct RegisterRemoteNotificationsAction {
    /// Errors occurring when registering for remote notifications.
    public enum ActionError: Error {
        /// The action was called while we were still waiting to receive a response from the previous one.
        case concurrentAccess
    }

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
    ///     if your app is not properly configured for remote notifications. It might also throw in the
    ///     rare circumstance where you make a call to this method while another one is still ongoing.
    ///     Try again to register at a later point in time.
    @MainActor
    @discardableResult
    public func callAsFunction() async throws -> Data {
        guard let spezi else {
            preconditionFailure("RegisterRemoteNotificationsAction was used in a scope where Spezi was not available anymore!")
        }

#if os(watchOS)
        let application = _Application.shared()
#else
        let application = _Application.shared
#endif

        let registration = spezi.storage[RemoteNotificationContinuation.self]
        if registration.continuation != nil {
            throw ActionError.concurrentAccess
        }

        return try await withCheckedThrowingContinuation { continuation in
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
    /// Below is a short code example on how to use this action within your ``Module``.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.registerRemoteNotifications)
    ///     var registerRemoteNotifications
    ///
    ///     func handleNotificationsAllowed() async throws {
    ///         let deviceToken = try await registerRemoteNotifications()
    ///         // .. send the device token to your remote server that generates push notifications
    ///     }
    /// }
    /// ```
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
        let registration = spezi.storage[RemoteNotificationContinuation.self]
        guard let continuation = registration.continuation else {
            // might also be called if, e.g., app is restored from backup and is automatically registered for remote notifications.
            // This can be handled through the `NotificationHandler` protocol.
            return
        }
        registration.continuation = nil
        continuation.resume(returning: deviceToken)
    }

    @MainActor
    static func handleFailedRegistration(_ spezi: Spezi, _ error: Error) {
        let registration = spezi.storage[RemoteNotificationContinuation.self]
        guard let continuation = registration.continuation else {
            spezi.logger.warning("Received a call to \(#function) while we were not waiting for a notifications registration request.")
            return
        }
        registration.continuation = nil
        continuation.resume(throwing: error)
    }
}
