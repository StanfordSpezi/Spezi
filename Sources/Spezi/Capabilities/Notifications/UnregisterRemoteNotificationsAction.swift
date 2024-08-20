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
/// - Important: Simulator devices cannot interact with APNS. Please skip this call on simulator devices and test APNS registration on a real device.
///
/// Below is a short code example on how to use this action within your ``Module``.
///
/// ```swift
/// class ExampleModule: Module {
///     @Application(\.unregisterRemoteNotifications)
///     var unregisterRemoteNotifications
///
///     func onAccountLogout() {
/// #if !targetEnvironment(simulator) // APNS interactions are unavailable on simulator devices
///         // handling your cleanup ...
///         unregisterRemoteNotifications()
/// #endif
///     }
/// }
/// ```
public struct UnregisterRemoteNotificationsAction {
    init() {}


    /// Unregisters for all remote notifications received through Apple Push Notification service.
#if targetEnvironment(simulator)
    @available(*, unavailable,
                message: """
                 Simulator devices cannot interact with APNS. Please skip this call on simulator devices and test APNS registration \
                 on a real device.
                 Refer to the Spezi documentation: https://swiftpackageindex.com/stanfordspezi/spezi/1.7.2/documentation/spezi/spezi/unregisterremotenotifications
                 """
    )
#endif
    @MainActor
    public func callAsFunction() {
#if !targetEnvironment(simulator)
#if os(watchOS)
        let application = _Application.shared()
#else
        let application = _Application.shared
#endif
        
        application.unregisterForRemoteNotifications()
#else
        preconditionFailure("\(Self.self) is not available on simulator devices.")
#endif
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
#if targetEnvironment(simulator)
    @available(*, unavailable,
                message: """
                 Simulator devices cannot interact with APNS services. Please skip this call on simulator devices and test APNS registration \
                 on a real device.
                 Refer to the Spezi documentation: https://swiftpackageindex.com/stanfordspezi/spezi/1.7.2/documentation/spezi/spezi/unregisterremotenotifications
                 """
    )
#endif
    public var unregisterRemoteNotifications: UnregisterRemoteNotificationsAction {
        UnregisterRemoteNotificationsAction()
    }
}
