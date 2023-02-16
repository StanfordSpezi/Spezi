//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import CryptoKit
import Foundation
import SecureStorage
import XCTRuntimeAssertions


final class SecureStorageTests: TestAppTestCase {
    let secureStorage: SecureStorage<TestAppStandard>
    
    
    init(secureStorage: SecureStorage<TestAppStandard>) {
        self.secureStorage = secureStorage
    }
    
    
    func runTests() async throws {
        try testCredentials()
        try testInternetCredentials()
        try testKeys()
    }
    
    func testCredentials() throws {
        var serverCredentials = Credentials(username: "@PSchmiedmayer", password: "CardinalKitInventor")
        try secureStorage.store(credentials: serverCredentials)
        try secureStorage.store(credentials: serverCredentials, storageScope: .keychainSynchronizable)
        try secureStorage.store(credentials: serverCredentials, storageScope: .keychainSynchronizable) // Overwrite existing credentials.
        
        let retrievedCredentials = try XCTUnwrap(secureStorage.retrieveCredentials("@PSchmiedmayer"))
        try XCTAssertEqual(serverCredentials, retrievedCredentials)
        try XCTAssertEqual(serverCredentials.id, retrievedCredentials.id)
        
        
        serverCredentials = Credentials(username: "@CardinalKit", password: "Paul")
        try secureStorage.updateCredentials("@PSchmiedmayer", newCredentials: serverCredentials)
        
        let retrievedUpdatedCredentials = try XCTUnwrap(secureStorage.retrieveCredentials("@CardinalKit"))
        try XCTAssertEqual(serverCredentials, retrievedUpdatedCredentials)
        
        
        try secureStorage.deleteCredentials("@CardinalKit")
        try XCTAssertNil(try secureStorage.retrieveCredentials("@CardinalKit"))
    }
    
    func testInternetCredentials() throws {
        var serverCredentials = Credentials(username: "@PSchmiedmayer", password: "CardinalKitInventor")
        try secureStorage.store(credentials: serverCredentials, server: "twitter.com")
        try secureStorage.store(credentials: serverCredentials, server: "twitter.com") // Overwrite existing credentials.
        try secureStorage.store(
            credentials: serverCredentials,
            server: "twitter.com",
            storageScope: .keychainSynchronizable
        )
        
        let retrievedCredentials = try XCTUnwrap(secureStorage.retrieveCredentials("@PSchmiedmayer", server: "twitter.com"))
        try XCTAssertEqual(serverCredentials, retrievedCredentials)
        
        
        serverCredentials = Credentials(username: "@CardinalKit", password: "Paul")
        try secureStorage.updateCredentials("@PSchmiedmayer", server: "twitter.com", newCredentials: serverCredentials, newServer: "stanford.edu")
        
        let retrievedUpdatedCredentials = try XCTUnwrap(secureStorage.retrieveCredentials("@CardinalKit", server: "stanford.edu"))
        try XCTAssertEqual(serverCredentials, retrievedUpdatedCredentials)
        
        
        try secureStorage.deleteCredentials("@CardinalKit", server: "stanford.edu")
        try XCTAssertNil(try secureStorage.retrieveCredentials("@CardinalKit", server: "stanford.edu"))
    }
    
    func testKeys() throws {
        try secureStorage.deleteKeys(forTag: "MyKey")
        try XCTAssertNil(try secureStorage.retrievePublicKey(forTag: "MyKey"))
        
        try secureStorage.createKey("MyKey", storageScope: .keychain)
        try secureStorage.createKey("MyKey", storageScope: .keychainSynchronizable)
        if SecureEnclave.isAvailable {
            try secureStorage.createKey("MyKey", storageScope: .secureEnclave)
        }
        
        let privateKey = try XCTUnwrap(secureStorage.retrievePrivateKey(forTag: "MyKey"))
        let publicKey = try XCTUnwrap(secureStorage.retrievePublicKey(forTag: "MyKey"))
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorX963SHA256AESGCM
        
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            throw XCTestFailure()
        }
        
        let plainText = Data("CardinalKit & Paul Schmiedmayer".utf8)
        
        var encryptError: Unmanaged<CFError>?
        guard let cipherText = SecKeyCreateEncryptedData(publicKey, algorithm, plainText as CFData, &encryptError) as Data? else {
            throw XCTestFailure()
        }
        
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            throw XCTestFailure()
        }
        
        var decryptError: Unmanaged<CFError>?
        guard let clearText = SecKeyCreateDecryptedData(privateKey, algorithm, cipherText as CFData, &decryptError) as Data? else {
            throw XCTestFailure()
        }
        
        try XCTAssertEqual(plainText, clearText)
        
        try secureStorage.deleteKeys(forTag: "MyKey")
        try XCTAssertNil(try secureStorage.retrievePrivateKey(forTag: "MyKey"))
        try XCTAssertNil(try secureStorage.retrievePublicKey(forTag: "MyKey"))
    }
}
