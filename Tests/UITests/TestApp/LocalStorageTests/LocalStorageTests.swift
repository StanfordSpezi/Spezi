//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CryptoKit
import LocalStorage
import SecureStorage
import XCTRuntimeAssertions


final class LocalStorageTests: TestAppTestCase {
    struct Letter: Codable, Equatable {
        let greeting: String
    }
    
    
    let localStorage: LocalStorage<TestAppStandard>
    let secureStorage: SecureStorage<TestAppStandard>
    
    
    init(
        localStorage: LocalStorage<TestAppStandard>,
        secureStorage: SecureStorage<TestAppStandard>
    ) {
        self.localStorage = localStorage
        self.secureStorage = secureStorage
    }
    
    
    func runTests() async throws {
        try await testLocalStorageTestEncryptedManualKeys()
        // Call test methods multiple times to test retrieval of keys.
        try await testLocalStorageTestEncryptedKeychain()
        try await testLocalStorageTestEncryptedKeychain()
        
        if SecureEnclave.isAvailable {
            try await testLocalStorageTestEncryptedSecureEnclave()
            try await testLocalStorageTestEncryptedSecureEnclave()
        }
    }
    
    func testLocalStorageTestEncryptedManualKeys() async throws {
        let privateKey = try secureStorage.retrievePrivateKey(forTag: "LocalStorageTests") ?? secureStorage.createKey("LocalStorageTests")
        guard let publicKey = try secureStorage.retrievePublicKey(forTag: "LocalStorageTests") else {
            throw XCTestFailure()
        }
        
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")
        
        try await localStorage.store(letter, settings: .encrypted(privateKey: privateKey, publicKey: publicKey))
        let storedLetter: Letter = try await localStorage.read(settings: .encrypted(privateKey: privateKey, publicKey: publicKey))
        
        try XCTAssertEqual(letter, storedLetter)
    }
    
    func testLocalStorageTestEncryptedKeychain() async throws {
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")

        try await localStorage.store(letter, settings: .encryptedUsingKeyChain())
        let storedLetter: Letter = try await localStorage.read(settings: .encryptedUsingKeyChain())

        try XCTAssertEqual(letter, storedLetter)
    }

    func testLocalStorageTestEncryptedSecureEnclave() async throws {
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")
        
        try await localStorage.store(letter, settings: .encryptedUsingSecureEnclave())
        let storedLetter: Letter = try await localStorage.read(settings: .encryptedUsingSecureEnclave())
        
        try XCTAssertEqual(letter, storedLetter)
    }
}
