//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


/// <#Description#>
public protocol HealthKitDataSourceDescription {
    /// <#Description#>
    var sampleTypes: Set<HKSampleType> { get }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - healthStore: <#healthStore description#>
    ///   - standard: <#standard description#>
    ///   - adapter: <#adapter description#>
    /// - Returns: <#description#>
    func dataSource<S: Standard>(healthStore: HKHealthStore, standard: S, adapter: HealthKit<S>.Adapter) -> HealthKitDataSource
}
