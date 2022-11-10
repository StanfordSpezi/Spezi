//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import HealthKit


actor TestAppHealthKitAdapter: SingleValueDataSourceRegistryAdapter {
    typealias InputType = HKSample
    typealias OutputType = TestAppStandard.BaseType
    
    
    func transform(element: HKSample) -> TestAppStandard.BaseType {
        TestAppStandard.BaseType(id: element.id)
    }
    
    func transform(id: UUID) -> UUID {
        id
    }
}
