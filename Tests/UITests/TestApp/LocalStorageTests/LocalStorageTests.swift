//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CryptoKit
@testable import LocalStorage
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
        try await testLocalStorageTestEncrypedManualKeys()
        // Call test methods multiple times to test retrieval of keys.
        try await testLocalStorageTestEncrypedKeychain()
        try await testLocalStorageTestEncrypedKeychain()
        
        if SecureEnclave.isAvailable {
            try await testLocalStorageTestEncrypedSecureEnclave()
            try await testLocalStorageTestEncrypedSecureEnclave()
        }
    }
    
    func testLocalStorageTestEncrypedManualKeys() async throws {
        let privateKey = try secureStorage.retrievePrivateKey(forTag: "LocalStorageTests") ?? secureStorage.createKey("LocalStorageTests")
        guard let publicKey = try secureStorage.retrievePublicKey(forTag: "LocalStorageTests") else {
            throw XCTestFailure()
        }
        
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")
        
        try await localStorage.store(letter, settings: .encryped(privateKey: privateKey, publicKey: publicKey))
        let storedLetter: Letter = try await localStorage.read(settings: .encryped(privateKey: privateKey, publicKey: publicKey))
        
        try XCTAssertEqual(letter, storedLetter)
    }
    
    func testLocalStorageTestEncrypedKeychain() async throws {
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")

        try await localStorage.store(letter, settings: .encrypedUsingKeyChain())
        let storedLetter: Letter = try await localStorage.read(settings: .encrypedUsingKeyChain())

        try XCTAssertEqual(letter, storedLetter)
    }

    func testLocalStorageTestEncrypedSecureEnclave() async throws {
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")
        
        try await localStorage.store(letter, settings: .encrypedUsingSecureEnclave())
        let storedLetter: Letter = try await localStorage.read(settings: .encrypedUsingSecureEnclave())
        
        try XCTAssertEqual(letter, storedLetter)
    }
}
