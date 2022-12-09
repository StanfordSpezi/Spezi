//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit
import SwiftUI


public protocol HealthKitDataSource: LifecycleHandler {
    func askedForAuthorization()
    func triggerDataSourceCollection() async
}


extension HealthKitDataSource {
    func askedForAuthorization(for sampleType: HKSampleType) -> Bool {
        let requestedSampleTypes = Set(UserDefaults.standard.stringArray(forKey: UserDefaults.Keys.healthKitRequestedSampleTypes) ?? [])
        return requestedSampleTypes.contains(sampleType.identifier)
    }
}
