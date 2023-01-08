//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@preconcurrency import HealthKit


actor TestAppHealthKitAdapter: SingleValueAdapter {
    typealias InputElement = HKSample
    typealias InputRemovalContext = UUID
    typealias OutputElement = TestAppStandard.BaseType
    typealias OutputRemovalContext = String
    
    
    func transform(element: HKSample) -> TestAppStandard.BaseType {
        TestAppStandard.BaseType(id: element.sampleType.identifier)
    }
    
    func transform(removalContext id: UUID) -> String {
        "Removed Element!"
    }
}
