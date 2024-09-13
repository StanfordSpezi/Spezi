//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UserNotifications


extension Spezi {
    /// An action to request notification authorization.
    ///
    /// Refer to ``Spezi/requestNotificationAuthorization`` for documentation.
    public struct RequestNotificationAuthorizationAction {
        /// Request notification authorization.
        /// - Parameter options: The authorization options your app is requesting.
        public func callAsFunction(options: UNAuthorizationOptions) async throws {
            try await UNUserNotificationCenter.current().requestAuthorization(options: options)
        }
    }

    /// Request notification authorization.
    ///
    /// ```swift
    /// struct MyModule: Module {
    ///     @Application(\.requestNotificationAuthorization)
    ///     private var requestNotificationAuthorization
    ///
    ///     func notificationPermissionWhileOnboarding() async throws -> Bool {
    ///         try await requestNotificationAuthorization(options: [.alert, .badge, .sound])
    ///     }
    /// }
    /// ```
    ///
    /// ## Topics
    /// ### Action
    /// - ``RequestNotificationAuthorizationAction``
    public var requestNotificationAuthorization: RequestNotificationAuthorizationAction {
        RequestNotificationAuthorizationAction()
    }
}


extension Spezi.RequestNotificationAuthorizationAction: Sendable {}
