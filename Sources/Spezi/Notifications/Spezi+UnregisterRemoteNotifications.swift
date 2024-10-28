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
/// Refer to the documentation of ``Spezi/unregisterRemoteNotifications``.
@_documentation(visibility: internal)
@available(*, deprecated, renamed: "Spezi.UnregisterRemoteNotificationsAction", message: "Please use Spezi.UnregisterRemoteNotificationsAction")
public typealias UnregisterRemoteNotificationsAction = Spezi.UnregisterRemoteNotificationsAction


extension Spezi {
    /// Unregisters for all remote notifications received through Apple Push Notification service.
    ///
    /// Refer to the documentation of ``Spezi/unregisterRemoteNotifications``.
    @available(*, deprecated, message: "Please migrate to the new SpeziNotifications package: https://github.com/StanfordSpezi/SpeziNotifications")
    public struct UnregisterRemoteNotificationsAction: Sendable {
        fileprivate init() {}


        /// Unregisters for all remote notifications received through Apple Push Notification service.
        @MainActor
        public func callAsFunction() {
            _Application.shared.unregisterForRemoteNotifications()
        }
    }

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
    @_disfavoredOverload
    @available(*, deprecated, message: "Please migrate to the new SpeziNotifications package: https://github.com/StanfordSpezi/SpeziNotifications")
    public var unregisterRemoteNotifications: UnregisterRemoteNotificationsAction {
        UnregisterRemoteNotificationsAction()
    }
}
