# ``SecureStorage``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Securely store small chunks of data, such as credentials and keys.

## Overview

The ``SecureStorage`` module allows for the encrypted storage of small chunks of sensitive user data, such as usernames and passwords for internet services, using Apple's [Keychain documentation](https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets). 

Credentials can be stored in the Secure Enclave (if available) or the Keychain. Credentials stored in the Keychain can be made synchronizable between different instances of user devices.


## Add the Secure Storage Component

You can configure the ``SecureStorage/SecureStorage`` component in the `CardinalKitAppDelegate`.
```swift
import CardinalKit
import SecureStorage


class ExampleDelegate: CardinalKitAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            SecureStorage()
        }
    }
}
```

You can then use the ``SecureStorage/SecureStorage`` class in any SwiftUI view.

```swift
struct ExampleSecureStorageView: View {
    @EnvironmentObject var secureStorage: SecureStorage<ExampleStandard>
    
    
    var body: some View {
        // ...
    }
}
```

Alternatively it is common to use the ``SecureStorage/SecureStorage`` component in other components as a dependency:

## Use the ``SecureStorage/SecureStorage`` component.

You can use the ``SecureStorage/SecureStorage`` component to store, update, retrieve, and delete credentials and keys. 


### Storing Credentials

Use the ``SecureStorage/SecureStorage`` component to store a set of ``Credentials`` instances in the Keychain associated with a server that is synchronizable between different devices.

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

The ``SecureStorage/SecureStorage`` component enables the retrieval of a previously stored set of credentials.

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

The ``SecureStorage/SecureStorage`` component enables the update of a previously stored set of credentials.

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

The ``SecureStorage/SecureStorage`` component enables the deletion of a previously stored set of credentials.

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

### Handeling Keys

Similiar to ``Credentials`` instances, you can also use the ``SecureStorage`` component to interact with keys.

- ``SecureStorage/SecureStorage/createKey(_:size:storageScope:)``
- ``SecureStorage/SecureStorage/retrievePrivateKey(forTag:)``
- ``SecureStorage/SecureStorage/retrievePublicKey(forTag:)``
- ``SecureStorage/SecureStorage/deleteKeys(forTag:)``
