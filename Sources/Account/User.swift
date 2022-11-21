//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI


public struct User {
    let name: PersonNameComponents
    private let imageLoader: () async -> Image?
    
    
    var image: Image? {
        get async {
            await imageLoader()
        }
    }
    
    
    public init(name: PersonNameComponents, imageLoader: @escaping () async -> Image? = { nil }) {
        self.name = name
        self.imageLoader = imageLoader
    }
}
