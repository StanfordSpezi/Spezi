//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UserNotifications


extension Spezi {
    /// An action to request the current user notifications settings.
    ///
    /// Refer to ``Spezi/notificationSettings`` for documentation.
    public struct NotificationSettingsAction {
        /// Request the current user notification settings.
        /// - Returns: Returns the current user notification settings.
        public func callAsFunction() async -> sending UNNotificationSettings {
            await UNUserNotificationCenter.current().notificationSettings()
        }
    }
    
    /// Retrieve the current notification settings of the application.
    ///
    /// ```swift
    /// struct MyModule: Module {
    ///     @Application(\.notificationSettings)
    ///     private var notificationSettings
    ///
    ///     func deliverNotification(request: UNNotificationRequest) async throws {
    ///         let settings = await notificationSettings()
    ///         guard settings.authorizationStatus == .authorized
    ///                 || settings.authorizationStatus == .provisional else {
    ///             return // notifications not permitted
    ///         }
    ///
    ///         // continue to add the notification request to the center ...
    ///     }
    /// }
    /// ```
    public var notificationSettings: NotificationSettingsAction {
        NotificationSettingsAction()
    }
}


extension Spezi.NotificationSettingsAction: Sendable {}
