# ``SecureStorage``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

A reusable `Module` that can be used to store store small chunks of data such as credentials and keys.

## Overview

The SecureStorage module allows for the encrypted storage of small chunks of sensitive user data, such as usernames and passwords for internet services, using Apple's [Keychain documentation](https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets). 

Credentials can be stored in the Secure Enclave (if available) or the Keychain. Credentials stored in the keychain can be made synchronizable between different instances of user devices.

### Storing Credentials

This example shows how to store a set of credentials in the Keychain, associated with a server, that is synchronizable between different devices.

```swift
do {
    let serverCredentials = Credentials(
        username: "user", 
        password: "password"
    )
    try secureStorage.store(
        credentials: serverCredentials, 
        server: "stanford.edu",
        storageScope: .keychainSynchronizable
    )
    // ...
} catch {
    // Handle creation error here.
    // ...
}
```

### Retrieving Credentials

This example shows how to retrieve the previously stored set of credentials.

```swift
if let serverCredentials = secureStorage.retrieveCredentials(
    "user", 
    server: "stanford.edu"
) {
    // Use credentials here.
    // ...
}
```

### Updating Credentials

This example shows how to update the previously stored set of credentials.

```swift
do {
    let newCredentials = Credentials(
        username: "user",
        password: "newPassword"
    )
    try secureStorage.updateCredentials(
        "user",
        server: "stanford.edu",
        newCredentials: newCredentials,
        newServer: "biodesign.stanford.edu"
    )
} catch {
    // Handle update error here.
    // ...
}
```

### Deleting Credentials

This example shows how to delete the previously stored set of credentials.

```swift
do {
    try secureStorage.deleteCredentials(
        "user", 
        server: "biodesign.stanford.edu"
    )
} catch {
    // Handle deletion error here.
    // ...
}
```
