//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// `true` when running on Linux in a Release (optimized) build.
///
/// On Linux Release builds, XCTRuntimeAssertions cannot intercept `preconditionFailure()` because
/// Swift Testing doesn't load XCTest, causing a real crash instead of a caught assertion.
let isLinuxRelease: Bool = {
    #if !os(Linux)
    return false
    #else
    var isDebug = false
    assert({ isDebug = true; return true }())
    return !isDebug
    #endif
}()
