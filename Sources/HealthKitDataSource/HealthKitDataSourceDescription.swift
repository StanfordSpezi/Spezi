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
    /// - Parameters:
    ///   - healthStore: <#healthStore description#>
    ///   - adapter: <#adapter description#>
    /// - Returns: <#description#>
    func dependency<S: Standard>(healthStore: HKHealthStore, adapter: HealthKit<S>.Adapter) -> any ComponentDependency<S>
}
