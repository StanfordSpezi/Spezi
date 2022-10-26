//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CryptoKit
import Security


enum SecureStorageError: Error {
    case createFailed(CFError? = nil)
    case notFound
    /// The error is thrown if an entitlement is missing to use the KeyChain.
    /// Refer to https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets
    /// about more information about the KeyChain services.
    ///
    /// If you try to use an access group to which your app doesn’t belong, the operation also fails and returns the `missingEntitlement` error.
    /// Please refer to https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps
    /// for more information about KeyChain access groups.
    /// Remove the  ``CredentialsStorage`` `accessGroup` configuration value if you do not intend to use KeyChain access groups.
    case missingEntitlement
    case unexpectedCredentialsData
    case keychainError(status: OSStatus)
}
