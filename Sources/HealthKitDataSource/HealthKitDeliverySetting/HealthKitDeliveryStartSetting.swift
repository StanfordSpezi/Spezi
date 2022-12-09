//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Determines when the HealthKit data collection is started.
public enum HealthKitDeliveryStartSetting: Equatable {
    /// The delivery is started the first time the ``HealthKit/triggerDataSourceCollection()`` function is called.
    case manual
    /// The delivery is started automatically after the user provided authorization and the application has launched.
    /// You can request authorization using the ``HealthKit/askForAuthorization()`` function.
    case afterAuthorizationAndApplicationWillLaunch // swiftlint:disable:this identifier_name
    // We use a name longer than 40 characters to indicate the full depth of this setting.
}
