//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension UserDefaults {
    enum Keys {
        static let healthKitRequestedSampleTypes = "CardinalKit.HealthKit.RequestedSampleTypes"
        static let healthKitAnchorPrefix = "CardinalKit.HealthKit.Anchors."
        static let healthKitDefaultPredicateDatePrefix = "CardinalKit.HealthKit.DefaultPredicateDate."
    }
}
