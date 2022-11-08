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


public class HealthKitDataSource<ComponentStandard: Standard, SampleType: HKSampleType>: Component, LifecycleHandler {
    let healthStore: HKHealthStore
    
    let sampleType: SampleType
    let predicate: NSPredicate?
    let deliverySetting: HealthKitDeliverySetting
    let adapter: HealthKit<ComponentStandard>.Adapter
    
    var active = false
    var anchor: HKQueryAnchor?
    
    @StandardActor var standard: ComponentStandard
    
    
    public required init( // swiftlint:disable:this function_default_parameter_at_end
        healthStore: HKHealthStore,
        sampleType: SampleType,
        predicate: NSPredicate? = nil, // We order the parameters in a logical order and therefore don't put the predicate at the end here.
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
        case .anchorQuery:
            active = true
            let healthKitSamples = await healthStore.anchoredObjectQuery(for: sampleType)
            await standard.registerDataSource(adapter.transform(healthKitSamples))
        case .background:
            active = true
            let healthKitSamples = healthStore.startObservation(for: [sampleType])
                .flatMap { _ in
                    AsyncThrowingStream { continuation in
                        Task {
                            let results = try await self.healthStore.anchoredObjectQuery(for: self.sampleType, using: self.anchor)
                            self.anchor = results.anchor
                            for result in results.elements {
                                continuation.yield(result)
                            }
                            continuation.finish()
                        }
                    }
                }
            await standard.registerDataSource(adapter.transform(healthKitSamples))
        }
    }
}
