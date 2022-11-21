//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


enum GenderIdentity: Int, CaseIterable, Identifiable, Hashable {
    case female
    case male
    case transgender
    case nonBinary
    case preferNotToState
    
    
    var id: Self {
        self
    }
    
    var localizedDescription: String {
        switch self {
        case .female:
            return String(localized: "GENDER_IDENTITY_FEMALE", bundle: .module)
        case .male:
            return String(localized: "GENDER_IDENTITY_MALE", bundle: .module)
        case .transgender:
            return String(localized: "GENDER_IDENTITY_TRANSGENDER", bundle: .module)
        case .nonBinary:
            return String(localized: "GENDER_IDENTITY_NON_BINARY", bundle: .module)
        case .preferNotToState:
            return String(localized: "GENDER_IDENTITY_PREFER_NOT_TO_STATE", bundle: .module)
        }
    }
}
