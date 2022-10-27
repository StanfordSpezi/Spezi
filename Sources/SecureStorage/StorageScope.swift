//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Security


/// <#Description#>
public enum StorageScope {
    /// <#Description#>
    case secureEnclave(userPresence: Bool = false)
    /// <#Description#>
    case keychain(userPresence: Bool = false, accessGroup: String? = nil)
    /// <#Description#>
    case keychainSynchronizable(userPresence: Bool = false, accessGroup: String? = nil)
    
    
    /// <#Description#>
    public static let secureEnclave = secureEnclave()
    /// <#Description#>
    public static let keychain = keychain()
    /// <#Description#>
    public static let keychainSynchronizable = keychainSynchronizable()
    
    
    var userPresence: Bool {
        switch self {
        case let .secureEnclave(userPresence), let .keychain(userPresence, _), let .keychainSynchronizable(userPresence, _):
            return userPresence
        }
    }
    
    var accessGroup: String? {
        switch self {
        case let .keychain(_, accessGroup), let .keychainSynchronizable(_, accessGroup):
            return accessGroup
        default:
            return nil
        }
    }
    
    var accessControl: SecAccessControl {
        get throws {
            // Follows https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility
            var secAccessControlCreateFlags: SecAccessControlCreateFlags = []
            let protection: CFTypeRef
            if self.userPresence {
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
            return access
        }
    }
}