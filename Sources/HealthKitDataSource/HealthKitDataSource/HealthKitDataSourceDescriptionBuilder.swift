//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A function builder used to generate HealthKit data source descriptions
@resultBuilder
public enum HealthKitDataSourceDescriptionBuilder {
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock(_ dataSourceDescriptions: HealthKitDataSourceDescription...) -> [HealthKitDataSourceDescription] {
        dataSourceDescriptions
    }
    
    /// Enables support for `if` statements that do not have an `else`.
    public static func buildOptional(_ dataSourceDescription: [HealthKitDataSourceDescription]?) -> [HealthKitDataSourceDescription] {
        // swiftlint:disable:previous discouraged_optional_collection
        // The optional collection is a requirement defined by @resultBuilder, we can not use a non-optional collection here.
        dataSourceDescription ?? []
    }

    /// With buildEither(second:), enables support for 'if-else' and 'switch' statements by folding conditional results into a single result.
    public static func buildEither(first: [HealthKitDataSourceDescription]) -> [HealthKitDataSourceDescription] {
        first
    }
    
    /// With buildEither(first:), enables support for 'if-else' and 'switch' statements by folding conditional results into a single result.
    public static func buildEither(second: [HealthKitDataSourceDescription]) -> [HealthKitDataSourceDescription] {
        second
    }
    
    /// Enables support for 'for..in' loops by combining the results of all iterations into a single result.
    public static func buildArray(_ dataSourceDescriptions: [[HealthKitDataSourceDescription]]) -> [HealthKitDataSourceDescription] {
        dataSourceDescriptions.flatMap { $0 }
    }
    
    /// If declared, this will be called on the partial result of an 'if #available' block to allow the result builder to erase type information.
    public static func buildLimitedAvailability(
        _ dataSourceDescription: [HealthKitDataSourceDescription]
    ) -> [HealthKitDataSourceDescription] {
        dataSourceDescription
    }
}
