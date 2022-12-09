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
    @MainActor @Published var name = PersonNameComponents()
    @MainActor @Published var gender: GenderIdentity?
    @MainActor @Published var dateOfBirth: Date?
    
    
    init(
        username: String? = nil,
        name: PersonNameComponents = PersonNameComponents(),
        gender: GenderIdentity? = nil,
        dateOfBirth: Date? = nil
    ) {
        Task { @MainActor in
            self.username = username
            self.name = name
            self.gender = gender
            self.dateOfBirth = dateOfBirth
        }
    }
}
