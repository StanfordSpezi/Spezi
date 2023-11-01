//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A collection of feature flags for the Spezi Test App app.
enum FeatureFlags {
    /// Run the lifecycleTests
    static let lifecycleTests = ProcessInfo.processInfo.arguments.contains("--lifecycleTests")
}
