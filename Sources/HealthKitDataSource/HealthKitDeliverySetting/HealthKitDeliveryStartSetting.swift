//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public enum HealthKitDeliveryStartSetting: Equatable {
    /// <#Description#>
    case manual
    /// <#Description#>
    case afterAuthorizationAndApplicationWillLaunch // swiftlint:disable:this identifier_name
    // We use a name longer than 40 characters to indicate the full depth of this setting.
}
