//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import CryptoKit
import Foundation
import LocalAuthentication
import Security


/// The ``SecureStorage`` serves as a resuable ``Module`` that can be used to store store small chunks of data such as credentials and keys.
///
/// The storing of credentials and keys follows the Keychain documentation provided by Apple: https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets.
class SecureStorage<ComponentStandard: Standard>: Module {
    struct Credentials {
        var username: String
        var password: String
    }
    
    enum SecureStorageError: Error {
        case createFailed(CFError? = nil)
        case notFound
        /// If you try to use an access group to which your app doesn’t belong, the operation fails and returns the `doesNotBelongToAccessGroup` error.
        ///
        /// Please refer to https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps
        /// for more information about KeyChain access groups.
        /// Remove the  ``CredentialsStorage`` `accessGroup` configuration value if you do not intend to use KeyChain access groups.
        case doesNotBelongToAccessGroup
        case unexpectedCredentialsData
        case keychainError(status: OSStatus)
    }
    
    
    private let accessGroup: String?
    private let synchronizable: Bool
    
    
    init(
        accessGroup: String? = nil,
        synchronizable: Bool = false
    ) {
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }
    
    
    // MARK: Key Handling
    
    func createKey(_ tag: String, userPresence: Bool = false) throws -> SecKey {
        // The key generation code follows
        // https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/protecting_keys_with_the_secure_enclave
        // and
        // https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/generating_new_cryptographic_keys
        var secAccessControlCreateFlags: SecAccessControlCreateFlags = [.privateKeyUsage]
        let protection: CFTypeRef
        if userPresence {
            secAccessControlCreateFlags.insert(.userPresence)
            protection = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        } else {
            protection = kSecAttrAccessibleAfterFirstUnlock
        }
        
        guard let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            protection,
            secAccessControlCreateFlags,
            nil
        ) else {
            throw SecureStorageError.createFailed()
        }
        
        var attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: Data(tag.utf8),
                kSecAttrAccessControl as String: access
            ]
        ]
        
        // Check that the device has a Secure Enclave
        if SecureEnclave.isAvailable {
          // Generate private key in Secure Enclave
          attributes[kSecAttrTokenID as String] = kSecAttrTokenIDSecureEnclave
        }
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error),
              let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw SecureStorageError.createFailed(error?.takeRetainedValue())
        }
        
        return publicKey
    }
    
    func retrievePublicKey(forTag tag: String) throws -> SecKey {
        // This method follows
        // https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain
        // for guidance.
        
        var item: CFTypeRef?
        try execute(SecItemCopyMatching(keyQuery(forTag: tag) as CFDictionary, &item))
        
        // Unfortunately we have to do a force cast here.
        // The compiler complains that "Conditional downcast to CoreFoundation type 'SecKey' will always succeed"
        // if we use `item as? SecKey`.
        let privateKey = (item as! SecKey) // swiftlint:disable:this force_cast
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw SecureStorageError.notFound
        }
        
        return publicKey
    }
    
    func deleteKeys(forTag tag: String) throws {
        try execute(SecItemDelete(keyQuery(forTag: tag) as CFDictionary))
    }
    
    private func keyQuery(forTag tag: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]
    }
    
    
    // MARK: Credentials Handling
    
    func store(credentials: Credentials, server: String? = nil) throws {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/adding_a_password_to_the_keychain.
        
        var query = queryFor(credentials.username, server: server)
        query[kSecValueData as String] = Data(credentials.password.utf8)
        query[kSecAttrSynchronizable as String] = synchronizable as CFBoolean
        
        try execute(SecItemAdd(query as CFDictionary, nil))
    }
    
    func deleteCredentials(_ username: String?, server: String?) throws {
        let query = queryFor(username, server: server)
        
        try execute(SecItemDelete(query as CFDictionary))
    }
    
    func updateCredentials( // swiftlint:disable:this function_default_parameter_at_end
        // The server parameter belongs to the `username` and therefore should be located next to the `username`.
        _ username: String,
        server: String? = nil,
        newCredentials: Credentials,
        newServer: String? = nil
    ) throws {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/updating_and_deleting_keychain_items
        
        let query = queryFor(username, server: server)
        
        var updateQuery = queryFor(newCredentials.username, server: newServer)
        updateQuery[kSecAttrSynchronizable as String] = synchronizable as CFBoolean
        
        try execute(SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary))
    }
    
    func retrieveCredentials(_ username: String?, server: String?) throws -> Credentials? {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/searching_for_keychain_items
        
        var query: [String: Any] = queryFor(username, server: server)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true
        
        var item: CFTypeRef?
        try execute(SecItemCopyMatching(query as CFDictionary, &item))
        
        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let account = existingItem[kSecAttrAccount as String] as? String else {
            throw SecureStorageError.unexpectedCredentialsData
        }
        
        return Credentials(username: account, password: password)
    }
    
    
    private func execute(_ secOperation: @autoclosure () -> (OSStatus)) throws {
        let status = secOperation()
        
        guard status != errSecItemNotFound else {
            throw SecureStorageError.notFound
        }
        guard status != errSecMissingEntitlement else {
            throw SecureStorageError.doesNotBelongToAccessGroup
        }
        guard status == errSecSuccess else {
            throw SecureStorageError.keychainError(status: status)
        }
    }
    
    private func queryFor(_ account: String?, server: String?) -> [String: Any] {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets
        
        var query: [String: Any] = [:]
        
        // Only append the account attribute if we got passed a non-nil account by the caller.
        if let account {
            query[kSecAttrAccount as String] = account
        }
        
        // Only append the accessGroup attribute if the `CredentialsStore` is configured to use KeyChain access groups
        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        // If the user provided us with a server associated with the credentials we assume it is an internet password.
        if server == nil {
            query[kSecClass as String] = kSecClassGenericPassword
        } else {
            query[kSecClass as String] = kSecClassInternetPassword
            // Only append the server attribute if we assume the credentials to be an internet password.
            query[kSecAttrServer as String] = server
        }
        
        return query
    }
}
