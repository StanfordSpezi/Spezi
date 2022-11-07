//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


public enum HealthKitDataSourceDeliverySetting {
    case manual
    case onWillFinishLaunchingWithOptions
    case background
}

public protocol HealthKitDataSourceDescription {
    func component<ComponentStandard: Standard>(_ standard: ComponentStandard.Type) -> any Component<ComponentStandard>
}


public struct Collect<SampleType: CorrelatingSampleType>: HealthKitDataSourceDescription {
    let type: SampleType
    let deliverySetting: HealthKitDataSourceDeliverySetting
    
    
    public init(type: SampleType, deliverySetting: HealthKitDataSourceDeliverySetting = .manual) {
        self.type = type
        self.deliverySetting = deliverySetting
    }
    
    
    public func component<ComponentStandard: Standard>(_ standard: ComponentStandard.Type = ComponentStandard.self) -> any Component<ComponentStandard> {
        switch deliverySetting {
        case .manual:
            return HealthKitUpdatingDataSource(sampleType: type, autoStart: false)
        case .onWillFinishLaunchingWithOptions:
            return HealthKitUpdatingDataSource(sampleType: type, autoStart: true)
        case .background:
            return HealthKitObserver()
        }
    }
}

public struct CollectECG: HealthKitDataSourceDescription {
    let autoStart: Bool
    
    
    public init(autoStart: Bool = false) {
        self.autoStart = autoStart
    }
    
    
    public func component<ComponentStandard: Standard>(_ standard: ComponentStandard.Type = ComponentStandard.self) -> any Component<ComponentStandard> {
        ECGHealthKitDataSource(autoStart: true)
    }
}


public class HealthKit<ComponentStandard: Standard>: ComponentCollection<ComponentStandard> {
    public init(_ healthKitDataSourceDescriptions: [HealthKitDataSourceDescription]) {
        super.init(elements:
            healthKitDataSourceDescriptions.compactMap {
                $0.component(ComponentStandard.self)
            }
        )
    }
}
