//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SecureStorage
import Security


/// The ``LocalStorageSetting`` enables configuring how data in the ``LocalStorage/LocalStorage`` module can be stored and retrieved.
public enum LocalStorageSetting {
    /// Unencrypted
    case unencrypted(excludedFromBackup: Bool = true)
    /// Encrypted using a `eciesEncryptionCofactorX963SHA256AESGCM` key: private key for encryption and a public key for decryption.
    case encrypted(privateKey: SecKey, publicKey: SecKey, excludedFromBackup: Bool = true)
    /// Encrypted using a `eciesEncryptionCofactorX963SHA256AESGCM` key stored in the Secure Enclave.
    case encryptedUsingSecureEnclave(userPresence: Bool = false)
    /// Encrypted using a `eciesEncryptionCofactorX963SHA256AESGCM` key stored in the Keychain.
    case encryptedUsingKeyChain(userPresence: Bool = false, excludedFromBackup: Bool = true)
    
    
    var excludedFromBackup: Bool {
        switch self {
        case let .unencrypted(excludedFromBackup),
             let .encrypted(_, _, excludedFromBackup),
             let .encryptedUsingKeyChain(_, excludedFromBackup):
            return excludedFromBackup
        case .encryptedUsingSecureEnclave:
            return true
        }
    }
    
    
    func keys<S: Standard>(from secureStorage: SecureStorage<S>) throws -> (privateKey: SecKey, publicKey: SecKey)? {
        let secureStorageScope: SecureStorageScope
        switch self {
        case .unencrypted:
            return nil
        case let .encrypted(privateKey, publicKey, _):
            return (privateKey, publicKey)
        case let .encryptedUsingSecureEnclave(userPresence):
            secureStorageScope = .secureEnclave(userPresence: userPresence)
        case let .encryptedUsingKeyChain(userPresence, _):
            secureStorageScope = .keychain(userPresence: userPresence)
        }
        
        let tag = "LocalStorage.\(secureStorageScope.id)"
        
        if let privateKey = try? secureStorage.retrievePrivateKey(forTag: tag),
           let publicKey = try? secureStorage.retrievePublicKey(forTag: tag) {
            return (privateKey, publicKey)
        }
        
        let privateKey = try secureStorage.createKey(tag)
        guard let publicKey = try secureStorage.retrievePublicKey(forTag: tag) else {
            throw LocalStorageError.encyptionNotPossible
        }
        
        return (privateKey, publicKey)
    }
}
