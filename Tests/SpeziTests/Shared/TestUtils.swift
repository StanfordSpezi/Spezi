//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Foundation

extension ProcessInfo {
    static let isReleaseTest: Bool = {
        #if DEBUG
        false
        #else
        true
        #endif
    }()
}
