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
public class SecureStorage<ComponentStandard: Standard>: Module {
    private let accessGroup: String?
    private let synchronizable: Bool
    
    
    public init(accessGroup: String? = nil, synchronizable: Bool = false) {
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }
    
    
    // MARK: Key Handling
    
    @discardableResult
    public func createKey(_ tag: String, size: Int = 256, userPresence: Bool = false) throws -> SecKey {
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
            kSecAttrKeySizeInBits as String: size as CFNumber,
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
    
    public func retrievePrivateKey(forTag tag: String) throws -> SecKey? {
        // This method follows
        // https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain
        // for guidance.
        
        var item: CFTypeRef?
        do {
            try execute(SecItemCopyMatching(keyQuery(forTag: tag) as CFDictionary, &item))
        } catch SecureStorageError.notFound {
            return nil
        } catch {
            throw error
        }
        
        // Unfortunately we have to do a force cast here.
        // The compiler complains that "Conditional downcast to CoreFoundation type 'SecKey' will always succeed"
        // if we use `item as? SecKey`.
        return (item as! SecKey) // swiftlint:disable:this force_cast
    }
    
    public func retrievePublicKey(forTag tag: String) throws -> SecKey? {
        guard let privateKey = try retrievePrivateKey(forTag: tag),
              let publicKey = SecKeyCopyPublicKey(privateKey) else {
            return nil
        }
        
        return publicKey
    }
    
    public func deleteKeys(forTag tag: String) throws {
        do {
            try execute(SecItemDelete(keyQuery(forTag: tag) as CFDictionary))
        } catch SecureStorageError.notFound {
            return
        } catch {
            throw error
        }
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
    
    public func store(credentials: Credentials, server: String? = nil, removeDuplicate: Bool = true) throws {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/adding_a_password_to_the_keychain.
        
        var query = queryFor(credentials.username, server: server)
        query[kSecValueData as String] = Data(credentials.password.utf8)
        query[kSecAttrSynchronizable as String] = synchronizable as CFBoolean
        
        do {
            try execute(SecItemAdd(query as CFDictionary, nil))
        } catch let SecureStorageError.keychainError(status) where status == -25299 && removeDuplicate {
            try deleteCredentials(credentials.username, server: server)
            try store(credentials: credentials, server: server, removeDuplicate: false)
        } catch {
            throw error
        }
    }
    
    public func deleteCredentials(_ username: String, server: String? = nil) throws {
        let query = queryFor(username, server: server)
        
        try execute(SecItemDelete(query as CFDictionary))
    }
    
    public func updateCredentials( // swiftlint:disable:this function_default_parameter_at_end
        // The server parameter belongs to the `username` and therefore should be located next to the `username`.
        _ username: String,
        server: String? = nil,
        newCredentials: Credentials,
        newServer: String? = nil,
        removeDuplicate: Bool = true
    ) throws {
        try deleteCredentials(username, server: server)
        try store(credentials: newCredentials, server: newServer, removeDuplicate: removeDuplicate)
    }
    
    public func retrieveCredentials(_ username: String, server: String? = nil) throws -> Credentials? {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/searching_for_keychain_items
        
        var query: [String: Any] = queryFor(username, server: server)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true
        
        var item: CFTypeRef?
        do {
            try execute(SecItemCopyMatching(query as CFDictionary, &item))
        } catch SecureStorageError.notFound {
            return nil
        } catch {
            throw error
        }
        
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
            throw SecureStorageError.missingEntitlement
        }
        guard status == errSecSuccess else {
            throw SecureStorageError.keychainError(status: status)
        }
    }
    
    private func queryFor(_ account: String, server: String?) -> [String: Any] {
        // This method uses code provided by the Apple Developer documentation at
        // https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets
        
        var query: [String: Any] = [:]
        query[kSecAttrAccount as String] = account
        
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
