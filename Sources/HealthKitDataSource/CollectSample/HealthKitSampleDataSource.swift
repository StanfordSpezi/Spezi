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


final class HealthKitSampleDataSource<ComponentStandard: Standard>: HealthKitDataSource {
    let healthStore: HKHealthStore
    let standard: ComponentStandard
    
    let sampleType: HKSampleType
    let predicate: NSPredicate?
    let deliverySetting: HealthKitDeliverySetting
    let adapter: HealthKit<ComponentStandard>.HKSampleAdapter
    
    var active = false
    
    private lazy var anchorUserDefaultsKey = UserDefaults.Keys.healthKitAnchorPrefix.appending(sampleType.identifier)
    private lazy var anchor: HKQueryAnchor? = loadAnchor() {
        didSet {
            saveAnchor()
        }
    }
    
    
    required init( // swiftlint:disable:this function_default_parameter_at_end
        healthStore: HKHealthStore,
        standard: ComponentStandard,
        sampleType: HKSampleType,
        predicate: NSPredicate? = nil, // We order the parameters in a logical order and therefore don't put the predicate at the end here.
        deliverySetting: HealthKitDeliverySetting,
        adapter: HealthKit<ComponentStandard>.HKSampleAdapter
    ) {
        self.healthStore = healthStore
        self.standard = standard
        self.sampleType = sampleType
        self.deliverySetting = deliverySetting
        self.adapter = adapter
        
        if predicate == nil {
            self.predicate = HKQuery.predicateForSamples(
                withStart: HealthKitSampleDataSource<ComponentStandard>.loadDefaultQueryDate(for: sampleType),
                end: nil,
                options: .strictEndDate
            )
        } else {
            self.predicate = predicate
        }
    }
    
    
    private static func loadDefaultQueryDate(for sampleType: HKSampleType) -> Date {
        let defaultPredicateDateUserDefaultsKey = UserDefaults.Keys.healthKitDefaultPredicateDatePrefix.appending(sampleType.identifier)
        guard let date = UserDefaults.standard.object(forKey: defaultPredicateDateUserDefaultsKey) as? Date else {
            // We start date collection at the previous full minute mark to make the
            // data collection deterministic to manually entered data in HealthKit.
            var components = Calendar.current.dateComponents(in: .current, from: .now)
            components.setValue(0, for: .second)
            components.setValue(0, for: .nanosecond)
            let defaultQueryDate = components.date ?? .now
            
            UserDefaults.standard.set(defaultQueryDate, forKey: defaultPredicateDateUserDefaultsKey)
            
            return defaultQueryDate
        }
        return date
    }
    
    
    func askedForAuthorization() {
        guard askedForAuthorization(for: sampleType) && !deliverySetting.isManual && !active else {
            return
        }
        
        Task {
            await triggerDataSourceCollection()
        }
    }
    
    func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        guard askedForAuthorization(for: sampleType) else {
            return
        }
        
        switch deliverySetting {
        case let .anchorQuery(startSetting, _) where startSetting == .afterAuthorizationAndApplicationWillLaunch,
            let .background(startSetting, _) where startSetting == .afterAuthorizationAndApplicationWillLaunch:
            Task {
                await triggerDataSourceCollection()
            }
        default:
            break
        }
    }
    
    func triggerDataSourceCollection() async {
        guard !active else {
            return
        }
        
        switch deliverySetting {
        case .manual:
            await standard.registerDataSource(adapter.transform(anchoredSingleObjectQuery()))
        case .anchorQuery:
            active = true
            await standard.registerDataSource(adapter.transform(anchoredContinousObjectQuery()))
        case .background:
            active = true
            let healthKitSamples = healthStore.startObservation(for: [sampleType], withPredicate: predicate)
                .flatMap { _ in
                    self.anchoredSingleObjectQuery()
                }
            await standard.registerDataSource(adapter.transform(healthKitSamples))
        }
    }
    
    
    private func anchoredSingleObjectQuery() -> AsyncThrowingStream<DataChange<HKSample, HKSampleRemovalContext>, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let results = try await healthStore.anchoredSingleObjectQuery(
                    for: self.sampleType,
                    using: self.anchor,
                    withPredicate: predicate
                )
                self.anchor = results.anchor
                for result in results.elements {
                    continuation.yield(result)
                }
                continuation.finish()
            }
        }
    }
    
    private func anchoredContinousObjectQuery() async -> any TypedAsyncSequence<DataChange<HKSample, HKSampleRemovalContext>> {
        AsyncThrowingStream { continuation in
            Task {
                try await healthStore.requestAuthorization(toShare: [], read: [sampleType])
                
                let anchorDescriptor = healthStore.anchorDescriptor(sampleType: sampleType, predicate: predicate, anchor: anchor)
                
                let updateQueue = anchorDescriptor.results(for: healthStore)
                
                do {
                    for try await results in updateQueue {
                        if Task.isCancelled {
                            continuation.finish()
                            return
                        }
                        
                        for deletedObject in results.deletedObjects {
                            continuation.yield(.removal(HKSampleRemovalContext(id: deletedObject.uuid, sampleType: sampleType)))
                        }
                        
                        for addedSample in results.addedSamples {
                            continuation.yield(.addition(addedSample))
                        }
                        self.anchor = results.newAnchor
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private func saveAnchor() {
        if deliverySetting.saveAnchor {
            guard let anchor,
                  let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: anchorUserDefaultsKey)
        }
    }
    
    private func loadAnchor() -> HKQueryAnchor? {
        guard deliverySetting.saveAnchor,
              let userDefaultsData = UserDefaults.standard.data(forKey: anchorUserDefaultsKey),
              let loadedAnchor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: userDefaultsData) else {
            return nil
        }
        
        return loadedAnchor
    }
}
