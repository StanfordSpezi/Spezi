# User Notifications

Manage and respond to User Notifications within your App and Modules.

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

## Overview

Spezi provides platform-agnostic mechanisms to manage and respond to User Notifications within your ``Module`` or ``Standard``.

### Handling Notifications

By adopting the ``NotificationHandler`` protocol for your `Module` or `Standard` you can easily respond to notification actions
or specify how to handle incoming notifications when your app is running in foreground.

Refer to the documentation of ``NotificationHandler/handleNotificationAction(_:)`` or ``NotificationHandler/receiveIncomingNotification(_:)``
respectively for more details.

### Remote Notifications

To register for remote notifications, you can use the ``Module/Application`` property and the corresponding ``Spezi/registerRemoteNotifications`` action.
Below is a short code example on how to use this action.

```swift
class ExampleModule: Module {
    @Application(\.registerRemoteNotifications)
    var registerRemoteNotifications

    func handleNotificationsAllowed() async throws {
        let deviceToken = try await registerRemoteNotifications()
        // .. send the device token to your remote server that generates push notifications
    }
}
```

> Tip: If you are just interested in monitoring the APNs device token, you can adopt the ``NotificationTokenHandler`` protocol for your `Module` or `Standard`
    and implement the ``NotificationTokenHandler/receiveUpdatedDeviceToken(_:)`` method.
    You might want to adopt this protocol requirement to be notified about an updated device token (e.g., after restoring from a backup).

Refer to the ``Spezi/unregisterRemoteNotifications`` action on how to unregister from remote notifications. 

#### Updating in the background

If you need to fetch additional content from the remote server when receiving a remote notification, you can
implement the ``NotificationHandler/receiveRemoteNotification(_:)`` method.

## Topics

### Notifications

- ``NotificationHandler``
- ``NotificationTokenHandler``

### Remote Notification Registration

- ``Spezi/registerRemoteNotifications``
- ``Spezi/unregisterRemoteNotifications``
