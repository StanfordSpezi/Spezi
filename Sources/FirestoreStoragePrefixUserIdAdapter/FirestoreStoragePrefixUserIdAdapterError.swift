//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Indicates an error on the ``FirestoreStoragePrefixUserIdAdapter``.
public enum FirestoreStoragePrefixUserIdAdapterError: Error {
    /// The user is not yet signed in.
    case userNotSignedIn
}
