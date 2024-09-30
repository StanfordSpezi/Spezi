//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Get notified about device token updates for APNs.
///
/// Use this protocol when your Module needs to be notified about an updated device tokens
/// for the Apple Push Notifications service.
public protocol NotificationTokenHandler {
    /// Receive an updated device token for APNs.
    ///
    /// User this method to be notified about a changed device token for interaction
    /// with the Apple Push Notifications service.
    /// Use this method to send the updated token to your server-side infrastructure.
    ///
    /// - Note: Fore more information refer to the documentation of
    ///     [`application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622958-application).
    /// - Parameter deviceToken: The globally unique token that identifies this device to APNs.
    @MainActor
    func receiveUpdatedDeviceToken(_ deviceToken: Data)
}
