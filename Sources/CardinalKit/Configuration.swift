//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
//
// This code is based on the Apodini (https://github.com/Apodini/Apodini) project.
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the Apodini project authors
//
// SPDX-License-Identifier: MIT
//


/// `Configuration`s are used to setup and configure different aspects of a ``CardinalKit/CardinalKit`` instance.
public protocol Configuration {
    /// The `configure(_: CardinalKit)` method can be used to perform any setup on a ``CardinalKit/CardinalKit`` instance.
    /// - Parameter cardinalKit: The configurable ``CardinalKit/CardinalKit`` instance.
    func configure(_ cardinalKit: CardinalKit)
}


extension Array: Configuration where Element == Configuration {
    /// Recursively class the ``Configuration/configure(_:)`` method of an `Array`.
    /// - Parameter cardinalKit: The configurable ``CardinalKit/CardinalKit`` instance.
    public func configure(_ cardinalKit: CardinalKit) {
        for configuration in self {
            configuration.configure(cardinalKit)
        }
    }
}
