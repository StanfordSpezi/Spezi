//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public enum HealthKitDeliverySetting: Equatable {
    /// <#Description#>
    case manual
    /// <#Description#>
    case anchorQuery(HealthKitDeliveryStartSetting)
    /// <#Description#>
    case background(HealthKitDeliveryStartSetting)
}
