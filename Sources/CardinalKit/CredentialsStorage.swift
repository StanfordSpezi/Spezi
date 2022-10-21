//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Security


/// The ``CredentialsStorage`` serves as a resuable ``Module`` that can be used to store credentials and keys on the device.
///
/// The storing of credentials and keys follows the Keychain documentation provided by Apple: https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets.
class CredentialsStorage<ComponentStandard: Standard>: Module {
    struct Credentials {
        var username: String
        var password: String
    }
    
    enum CredentialsError: Error {
        case noCredentials
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
            throw CredentialsError.unexpectedCredentialsData
        }
        
        return Credentials(username: account, password: password)
    }
    
    
    private func execute(_ secOperation: @autoclosure () -> (OSStatus)) throws {
        let status = secOperation()
        
        guard status != errSecItemNotFound else {
            throw CredentialsError.noCredentials
        }
        guard status != errSecMissingEntitlement else {
            throw CredentialsError.doesNotBelongToAccessGroup
        }
        guard status == errSecSuccess else {
            throw CredentialsError.keychainError(status: status)
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
