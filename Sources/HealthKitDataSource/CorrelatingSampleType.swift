//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit


public protocol CorrelatingSampleType: HKSampleType {
    associatedtype Sample: HKSample
}


extension HKElectrocardiogramType: CorrelatingSampleType {
    public typealias Sample = HKElectrocardiogram
}

extension HKCategoryType: CorrelatingSampleType {
    public typealias Sample = HKCategorySample
}
