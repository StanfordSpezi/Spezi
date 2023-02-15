//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Determines the data delivery settings for any ``HealthKitDataSource`` used in the HealthKit component.
public enum HealthKitDeliverySetting: Equatable {
    /// The HealthKit data is manually collected when the ``HealthKit/triggerDataSourceCollection()`` function is called.
    case manual(safeAnchor: Bool = true)
    /// The HealthKit data is collected based on the `HealthKitDeliveryStartSetting` and constantly listens to updates while the application is running.
    /// If `safeAnchor` is enabled the `HKQueryAnchor` is persisted across multiple application launches using the user defaults.
    case anchorQuery(HealthKitDeliveryStartSetting = .afterAuthorizationAndApplicationWillLaunch, saveAnchor: Bool = true)
    /// The HealthKit data is collected based on the `HealthKitDeliveryStartSetting` and constantly listens to updates even if the application is not running.
    /// If `safeAnchor` is enabled the `HKQueryAnchor` is persisted across multiple application launches using the user defaults.
    case background(HealthKitDeliveryStartSetting = .afterAuthorizationAndApplicationWillLaunch, saveAnchor: Bool = true)
    
    
    var saveAnchor: Bool {
        switch self {
        case let .manual(saveAnchor):
            return saveAnchor
        case let .anchorQuery(_, saveAnchor):
            return saveAnchor
        case let .background(_, saveAnchor):
            return saveAnchor
        }
    }
    
    var isManual: Bool {
        switch self {
        case .manual:
            return true
        case let .anchorQuery(healthKitDeliveryStartSetting, _), let .background(healthKitDeliveryStartSetting, _):
            return healthKitDeliveryStartSetting == .manual
        }
    }
}
