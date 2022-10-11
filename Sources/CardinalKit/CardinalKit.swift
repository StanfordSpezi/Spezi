//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Contains a nice text to say hello
public struct CardinalKit {
    /// Generates a greeting from the CardinalKitCardinalKit
    /// - Parameter name: The name that should be greeted, the default value is `"CardinalKit"`
    /// - Returns: The greeting created by the CardinalKit
    public func greet(_ name: String = "CardinalKit") async throws -> String {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return "Hello, \(name)!"
    }
}
