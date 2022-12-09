//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// A custom error to document test failures of the XCTRuntimeAssertions target.
public struct XCTFail: Error, CustomStringConvertible {
    /// Message associated with the test failure.
    public let message: String
    
    
    public var description: String {
        message
    }
}
