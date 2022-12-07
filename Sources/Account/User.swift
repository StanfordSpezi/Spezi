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
    
    
    /// Creates a new ``User`` instance.
    /// - Parameters:
    ///   - name: The name of a ``User`` using `PersonNameComponents`. It is recommended to provide the family name and given name if applicable.
    public init(name: PersonNameComponents) {
        self.name = name
    }
    
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name
    }
}
