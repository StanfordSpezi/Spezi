//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


enum AccountInputFields: Hashable {
    case username
    case password
    case passwordRepeat
    case givenName
    case familyName
    case genderIdentity
    case dateOfBirth
    case phoneNumber
}
