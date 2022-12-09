//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// An error thrown by the ``LocalStorage/LocalStorage`` module.
enum LocalStorageError: Error {
    /// Encryption of the file was not possible, did not store the data on disk.
    case encyptionNotPossible
    /// Adding the file descriptor to exclude the file from backup could not be achieved.
    case couldNotExcludedFromBackup
    /// Decrypting the file was not possible with the given ``LocalStorageSetting``, please check that this is the ``LocalStorageSetting`` that you used to store the element.
    case decryptionNotPossible
    /// The file requested to be deleted exists but deleting the file was not possible.
    case deletionNotPossible
}
