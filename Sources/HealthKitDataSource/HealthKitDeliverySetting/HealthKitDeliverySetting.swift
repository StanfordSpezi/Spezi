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
    case manual(safeAnchor: Bool = true)
    /// <#Description#>
    case anchorQuery(HealthKitDeliveryStartSetting = .afterAuthorizationAndApplicationWillLaunch, safeAnchor: Bool = true)
    /// <#Description#>
    case background(HealthKitDeliveryStartSetting = .afterAuthorizationAndApplicationWillLaunch, safeAnchor: Bool = true)
    
    
    var saveAnchor: Bool {
        switch self {
        case let .manual(safeAnchor):
            return safeAnchor
        case let .anchorQuery(_, safeAnchor):
            return safeAnchor
        case let .background(_, safeAnchor):
            return safeAnchor
        }
    }
    
    var isManual: Bool {
        switch self {
        case .manual:
            return true
        default:
            return false
        }
    }
}
