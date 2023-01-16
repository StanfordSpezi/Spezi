//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


final class AccessCodeService: ObservableObject {
    @Published private(set) var locked = true
    
    
    init() { }
}
