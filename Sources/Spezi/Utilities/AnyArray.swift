//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A type erase `Array`.
public protocol AnyArray {
    /// The `Element` type of the Array.
    associatedtype Element


    /// Provides access to the unwrapped array type.
    var unwrappedArray: [Element] { get }
}


extension Array: AnyArray {
    public var unwrappedArray: [Element] {
        self
    }
}
