//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI


/// A ``User`` 
public struct User: Equatable {
    /// The name of a ``User`` using `PersonNameComponents`. It is recommended to provide the family name and given name if applicable.
    public let name: PersonNameComponents
    private let imageLoader: () async -> Image?
    
    
    /// A optional profile image for the ``User``
    public var image: Image? {
        get async {
            await imageLoader()
        }
    }
    
    
    /// Creates a new ``User`` instance.
    /// - Parameters:
    ///   - name: The name of a ``User`` using `PersonNameComponents`. It is recommended to provide the family name and given name if applicable.
    ///   - imageLoader: A optional profile image for the ``User`` that can be provided usign an async closure.
    public init(name: PersonNameComponents, imageLoader: @escaping () async -> Image? = { nil }) {
        self.name = name
        self.imageLoader = imageLoader
    }
    
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name
    }
}
