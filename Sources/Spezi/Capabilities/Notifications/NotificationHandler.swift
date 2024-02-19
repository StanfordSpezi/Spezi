//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UserNotifications


/// Get notified about receiving notifications.
public protocol NotificationHandler {
#if !os(tvOS)
    /// Handle user-selected notification action.
    ///
    /// This method is called with your app in the background to handle the selected user action.
    ///
    /// For more information refer to [Handle user-selected actions](https://developer.apple.com/documentation/usernotifications/handling-notifications-and-notification-related-actions#Handle-user-selected-actions)
    /// and [`userNotificationCenter(_:didReceive:withCompletionHandler:)`](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate/usernotificationcenter(_:didreceive:withcompletionhandler:)).
    ///
    /// - Note: Notification Actions are not supported on `tvOS`.
    ///
    /// - Parameter response: The user's response to the notification.
    func handleNotificationAction(_ response: UNNotificationResponse) async
#endif

    /// Handle incoming notification when the app is running in foreground.
    ///
    /// This method is called when there is a incoming notification while the app was running in foreground.
    ///
    /// For more information refer to
    /// [Handle notifications while your app runs in the foreground](https://developer.apple.com/documentation/usernotifications/handling-notifications-and-notification-related-actions#Handle-notifications-while-your-app-runs-in-the-foreground)
    /// and [`userNotificationCenter(_:willPresent:withCompletionHandler:)`](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate/usernotificationcenter(_:willpresent:withcompletionhandler:)).
    ///
    /// - Parameter notification: The notification that is about to be delivered.
    /// - Returns: The option for notifying the user. Use `[]` to silence the notification.
    func receiveIncomingNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions?

#if !os(macOS)
    /// Handle remote notification when the app is running in background.
    ///
    /// This method is called when there is a remote notification arriving while the app is running in background.
    /// You can use this method to download additional content.
    ///
    /// For more information refer to
    /// [`application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623013-application)
    /// or [`didReceiveRemoteNotification(_:fetchCompletionHandler:)`](https://developer.apple.com/documentation/watchkit/wkextensiondelegate/3152235-didreceiveremotenotification).
    ///
    /// - Note: The signature for this method on macOS is slightly different. It is not `async` and doesn't have a return value.
    ///
    /// - Parameter remoteNotification: The data of the notification payload.
    /// - Returns: Return the respective ``BackgroundFetchResult``.
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) async -> BackgroundFetchResult
#else
    /// Handle remote notification when the app is running in background.
    ///
    /// This method is called when there is a remote notification arriving while the app is running in background.
    /// You can use this method to download additional content.
    ///
    /// For more information refer to
    /// [`application(_:didReceiveRemoteNotification:)`](https://developer.apple.com/documentation/appkit/nsapplicationdelegate/1428430-application).
    ///
    /// - Parameter remoteNotification: The data of the notification payload.
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any])
#endif
}


extension NotificationHandler {
#if !os(tvOS)
    /// Empty default implementation.
    func handleNotificationAction(_ response: UNNotificationResponse) async {}
#endif

    /// Empty default implementation.
    func receiveIncomingNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions? {
        nil
    }

#if !os(macOS)
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) async -> BackgroundFetchResult {
        .noData
    }
#else
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable: Any]) {}
#endif
}
