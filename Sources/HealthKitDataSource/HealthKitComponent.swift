//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit
import SwiftUI


protocol HealthKitComponent: Component, LifecycleHandler {
    func askedForAuthorization()
    func triggerDataSourceCollection() async
}


extension HealthKitComponent {
    func askedForAuthorization(for sampleType: HKSampleType) -> Bool {
        let requestedSampleTypes = Set(UserDefaults.standard.stringArray(forKey: UserDefaults.Keys.healthKitRequestedSampleTypes) ?? [])
        return requestedSampleTypes.contains(sampleType.identifier)
    }
}
