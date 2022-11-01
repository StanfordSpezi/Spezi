//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SecureStorage
import Security


/// The ``LocalStorageSetting`` enables configuring how data in the ``LocalStorage/LocalStorage`` module can be stored and retrieved.
public enum LocalStorageSetting {
    /// Encryped using a `eciesEncryptionCofactorX963SHA256AESGCM` key: private key for encryption and a public key for decryption.
    case unencryped(excludedFromBackup: Bool = true)
    /// Encryped using a `eciesEncryptionCofactorX963SHA256AESGCM` key: private key for encryption and a public key for decryption.
    case encryped(privateKey: SecKey, publicKey: SecKey, excludedFromBackup: Bool = true)
    /// Encryped using a `eciesEncryptionCofactorX963SHA256AESGCM` key stored in the Secure Enclave.
    case encrypedUsingSecureEnclave(userPresence: Bool = false)
    /// Encryped using a `eciesEncryptionCofactorX963SHA256AESGCM` key stored in the Keychain.
    case encrypedUsingKeyChain(userPresence: Bool = false, excludedFromBackup: Bool = true)
    
    
    func keys<S: Standard>(from secureStorage: SecureStorage<S>) throws -> (privateKey: SecKey, publicKey: SecKey)? {
        let secureStorageScope: SecureStorageScope
        switch self {
        case .unencryped:
            return nil
        case let .encryped(privateKey, publicKey, _):
            return (privateKey, publicKey)
        case let .encrypedUsingSecureEnclave(userPresence):
            secureStorageScope = .secureEnclave(userPresence: userPresence)
        case let .encrypedUsingKeyChain(userPresence, _):
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
