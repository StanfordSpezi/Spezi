//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Describes the self-identified gender identity
public enum GenderIdentity: Int, Sendable, CaseIterable, Identifiable, Hashable, CustomLocalizedStringResourceConvertible {
    /// Self-identify as female
    case female
    /// Self-identify as male
    case male
    /// Self-identify as transgender
    case transgender
    /// Self-identify as non-binary
    case nonBinary
    /// Prefer not to state the self-identified gender
    case preferNotToState
    
    
    public var id: RawValue {
        rawValue
    }
    
    public var localizedStringResource: LocalizedStringResource {
        switch self {
        case .female:
            return LocalizedStringResource("GENDER_IDENTITY_FEMALE", bundle: .atURL(Bundle.module.bundleURL))
        case .male:
            return LocalizedStringResource("GENDER_IDENTITY_MALE", bundle: .atURL(Bundle.module.bundleURL))
        case .transgender:
            return LocalizedStringResource("GENDER_IDENTITY_TRANSGENDER", bundle: .atURL(Bundle.module.bundleURL))
        case .nonBinary:
            return LocalizedStringResource("GENDER_IDENTITY_NON_BINARY", bundle: .atURL(Bundle.module.bundleURL))
        case .preferNotToState:
            return LocalizedStringResource("GENDER_IDENTITY_PREFER_NOT_TO_STATE", bundle: .atURL(Bundle.module.bundleURL))
        }
    }
}
