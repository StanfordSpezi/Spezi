//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Unregisters for all remote notifications received through Apple Push Notification service.
///
/// For more information refer to the [`unregisterForRemoteNotifications()`](https://developer.apple.com/documentation/uikit/uiapplication/1623093-unregisterforremotenotifications)
/// documentation for `UIApplication` or for the respective equivalent for your current platform.
///
/// Below is a short code example on how to use this action within your ``Module``.
///
/// ```swift
/// class ExampleModule: Module {
///     @Application(\.unregisterRemoteNotifications)
///     var unregisterRemoteNotifications
///
///     func onAccountLogout() {
///         // handling your cleanup ...
///         unregisterRemoteNotifications()
///     }
/// }
/// ```
public struct UnregisterRemoteNotificationsAction {
    init() {}


    /// Unregisters for all remote notifications received through Apple Push Notification service.
    public func callAsFunction() {
#if os(watchOS)
        let application = _Application.shared()
#else
        let application = _Application.shared
#endif
        
        application.unregisterForRemoteNotifications()
    }
}


extension Spezi {
    /// Unregisters for all remote notifications received through Apple Push Notification service.
    ///
    /// For more information refer to the [`unregisterForRemoteNotifications()`](https://developer.apple.com/documentation/uikit/uiapplication/1623093-unregisterforremotenotifications)
    /// documentation for `UIApplication` or for the respective equivalent for your current platform.
    ///
    /// Below is a short code example on how to use this action within your ``Module``.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.unregisterRemoteNotifications)
    ///     var unregisterRemoteNotifications
    ///
    ///     func onAccountLogout() {
    ///         // handling your cleanup ...
    ///         unregisterRemoteNotifications()
    ///     }
    /// }
    /// ```
    ///
    /// ## Topics
    /// ### Action
    /// - ``UnregisterRemoteNotificationsAction``
    public var unregisterRemoteNotifications: UnregisterRemoteNotificationsAction {
        UnregisterRemoteNotificationsAction()
    }
}
