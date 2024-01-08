//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension ProcessInfo {
    static let xcodeRunningForPreviewKey = "XCODE_RUNNING_FOR_PREVIEWS"


    /// Check if the current process is running in a simulator inside a Xcode preview.
    public var isPreviewSimulator: Bool {
        environment[Self.xcodeRunningForPreviewKey] == "1"
    }
}
