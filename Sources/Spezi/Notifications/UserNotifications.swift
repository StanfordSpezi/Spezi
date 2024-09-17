//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import UserNotifications


/// Interact with local notifications.
///
/// This module provides some easy to use API to schedule and manage local notifications.
///
/// ## Topics
///
/// ### Configuration
/// - ``init()``
///
/// ### Badge Count
/// - ``setBadgeCount(_:)``
///
/// ### Add a Notification Request
/// - ``add(request:)``
///
/// ### Notification Limits
/// - ``pendingNotificationsLimit``
/// - ``remainingNotificationLimit()``
///
/// ### Fetching Notifications
/// - ``pendingNotificationRequests()``
/// - ``deliveredNotifications()``
///
/// ### Categories
/// - ``add(categories:)``
public final class LocalNotifications: Module, DefaultInitializable, EnvironmentAccessible {
    /// The total limit of simultaneously scheduled notifications.
    ///
    /// The limit is `64`.
    public static let pendingNotificationsLimit = 64

    /// Configure the local notifications module.
    public init() {}

#if compiler(>=6)
    /// Updates the badge count for your app’s icon.
    /// - Parameters:
    ///   - isolation: Inherits the current isolation.
    ///   - badgeCount: The new badge count to display.
    public func setBadgeCount( // swiftlint:disable:this function_default_parameter_at_end
        isolation: isolated (any Actor)? = #isolation,
        _ badgeCount: Int
    ) async throws {
        try await UNUserNotificationCenter.current().setBadgeCount(badgeCount)
    }
#else
    public func setBadgeCount(_ badgeCount: Int) async throws {
        try await UNUserNotificationCenter.current().setBadgeCount(badgeCount)
    }
#endif

#if compiler(>=6)
    /// Schedule a new notification request.
    /// - Parameters:
    ///   - isolation: Inherits the current isolation.
    ///   - request: The notification request.
    public func add( // swiftlint:disable:this function_default_parameter_at_end
        isolation: isolated (any Actor)? = #isolation,
        request: sending UNNotificationRequest
    ) async throws {
        try await UNUserNotificationCenter.current().add(request)
    }
#else
    /// Schedule a new notification request.
    /// - Parameter request: The notification request.
    public func add(request: UNNotificationRequest) async throws {
        try await UNUserNotificationCenter.current().add(request)
    }
#endif

#if compiler(>=6)
    /// Retrieve the amount of notifications that can be scheduled for the app.
    ///
    /// An application has a total limit of ``pendingNotificationsLimit`` that can be scheduled (pending). This method retrieve the reaming notifications that can be scheduled.
    ///
    /// - Note: Already delivered notifications do not count towards this limit.
    /// - Parameter isolation: Inherits the current isolation.
    /// - Returns: Returns the remaining amount of notifications that can be scheduled for the application.
    public func remainingNotificationLimit(isolation: isolated (any Actor)? = #isolation) async -> Int {
        let pendingRequests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return max(0, Self.pendingNotificationsLimit - pendingRequests.count)
    }
#else
    /// Retrieve the amount of notifications that can be scheduled for the app.
    ///
    /// An application has a total limit of ``pendingNotificationsLimit`` that can be scheduled (pending). This method retrieve the reaming notifications that can be scheduled.
    ///
    /// - Note: Already delivered notifications do not count towards this limit.
    /// - Returns: Returns the remaining amount of notifications that can be scheduled for the application.
    public func remainingNotificationLimit() async -> Int {
        let pendingRequests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return max(0, Self.pendingNotificationsLimit - pendingRequests.count)
    }
#endif

#if compiler(>=6)
    /// Fetch all notification requests that are pending delivery.
    /// - Parameter isolation: Inherits the current isolation.
    /// - Returns: The array of pending notifications requests.
    public func pendingNotificationRequests(isolation: isolated (any Actor)? = #isolation) async -> sending [UNNotificationRequest] {
        await UNUserNotificationCenter.current().pendingNotificationRequests()
    }
#else
    /// Fetch all notification requests that are pending delivery.
    /// - Returns: The array of pending notifications requests.
    public func pendingNotificationRequests() async -> [UNNotificationRequest] {
        await UNUserNotificationCenter.current().pendingNotificationRequests()
    }
#endif

#if compiler(>=6)
    /// Fetch all delivered notifications that are still shown in the notification center.
    /// - Parameter isolation: Inherits the current isolation.
    /// - Returns: The array of local and remote notifications that have been delivered and are still show in the notification center.
    @available(tvOS, unavailable)
    public func deliveredNotifications(isolation: isolated (any Actor)? = #isolation) async -> sending [UNNotification] {
        await UNUserNotificationCenter.current().deliveredNotifications()
    }
#else
    /// Fetch all delivered notifications that are still shown in the notification center.
    /// - Returns: The array of local and remote notifications that have been delivered and are still show in the notification center.
    @available(tvOS, unavailable)
    public func deliveredNotifications() async -> [UNNotification] {
        await UNUserNotificationCenter.current().deliveredNotifications()
    }
#endif

#if compiler(>=6)
    /// Add additional notification categories.
    ///
    /// This method adds additional notification categories. Call this method within your configure method of your Module to ensure that categories are configured
    /// as early as possible.
    ///
    /// To receive the action that are performed for your category, implement the ``NotificationHandler/handleNotificationAction(_:)`` method of the
    /// ``NotificationHandler`` protocol.
    ///
    /// - Note: Aim to only call this method once at startup.
    ///
    /// - Parameters:
    ///   - isolation: Inherits the current isolation.
    ///   - categories: The notification categories you support.
    @available(tvOS, unavailable)
    public func add( // swiftlint:disable:this function_default_parameter_at_end
        isolation: isolated (any Actor)? = #isolation,
        categories: Set<UNNotificationCategory>
    ) async {
        let previousCategories = await UNUserNotificationCenter.current().notificationCategories()
        UNUserNotificationCenter.current().setNotificationCategories(categories.union(previousCategories))
    }
#else
    /// Add additional notification categories.
    ///
    /// This method adds additional notification categories. Call this method within your configure method of your Module to ensure that categories are configured
    /// as early as possible.
    ///
    /// To receive the action that are performed for your category, implement the ``NotificationHandler/handleNotificationAction(_:)`` method of the
    /// ``NotificationHandler`` protocol.
    ///
    /// - Note: Aim to only call this method once at startup.
    ///
    /// - Parameter categories: The notification categories you support.
    @available(tvOS, unavailable)
    public func add(categories: Set<UNNotificationCategory>) async {
        let previousCategories = await UNUserNotificationCenter.current().notificationCategories()
        UNUserNotificationCenter.current().setNotificationCategories(categories.union(previousCategories))
    }
#endif
}
