//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Account
import Foundation


actor User: ObservableObject {
    @MainActor @Published var username: String?
    
    
    init(
        username: String? = nil
    ) {
        Task { @MainActor in
            self.username = username
        }
    }
}
