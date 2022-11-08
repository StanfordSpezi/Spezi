//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


public enum HealthKitDeliverySetting: Equatable {
    case manual
    case anchorQuery(HealthKitDeliveryStartSetting)
    case background(HealthKitDeliveryStartSetting)
}


public enum HealthKitDeliveryStartSetting: Equatable {
    case manual
    case applicationWillLaunch
}


public class HealthKitDataSource<ComponentStandard: Standard, SampleType: CorrelatingSampleType>: Component, LifecycleHandler {
    let healthStore: HKHealthStore
    
    let sampleType: SampleType
    let predicate: NSPredicate?
    let deliverySetting: HealthKitDeliverySetting
    let adapter: HealthKit<ComponentStandard>.Adapter
    
    var active = false
    var anchor: HKQueryAnchor?
    
    @StandardActor var standard: ComponentStandard
    
    
    public required init(
        healthStore: HKHealthStore,
        sampleType: SampleType,
        predicate: NSPredicate? = nil,
        deliverySetting: HealthKitDeliverySetting,
        adapter: HealthKit<ComponentStandard>.Adapter
    ) {
        self.healthStore = healthStore
        self.sampleType = sampleType
        self.predicate = predicate
        self.deliverySetting = deliverySetting
        self.adapter = adapter
    }
    
    
    func triggerDataSourceCollection() async {
        guard deliverySetting != .manual, !active else {
            return
        }
        
        switch deliverySetting {
        case .manual:
            let healthKitSamples = healthStore.sampleQueryStream(for: sampleType, withPredicate: predicate)
            await standard.registerDataSource(adapter.transform(healthKitSamples))
            break
        case .anchorQuery:
            active = true
            let healthKitSamples = await healthStore.anchoredObjectQuery(for: sampleType)
            await standard.registerDataSource(adapter.transform(healthKitSamples))
            break
        case .background:
            active = true
            let healthKitSamples = healthStore.startObservation(for: [sampleType])
                .flatMap { types in
                    AsyncThrowingStream { continuation in
                        Task {
                            let results = try await self.healthStore.anchoredObjectQuery(for: self.sampleType, using: self.anchor)
                            self.anchor = results.1
                            for result in results.0 {
                                continuation.yield(result)
                            }
                            continuation.finish()
                        }
                    }
                }
            await standard.registerDataSource(adapter.transform(healthKitSamples))
            break
        }
    }
}
