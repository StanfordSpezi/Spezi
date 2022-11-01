//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import LocalStorage
import SecureStorage
import XCTRuntimeAssertions


final class LocalStorageTests {
    struct Letter: Codable, Equatable {
        let greeting: String
    }
    
    
    let localStorage: LocalStorage<UITestsAppStandard>
    let secureStorage: SecureStorage<UITestsAppStandard>
    
    
    init(
        localStorage: LocalStorage<UITestsAppStandard>,
        secureStorage: SecureStorage<UITestsAppStandard>
    ) {
        self.localStorage = localStorage
        self.secureStorage = secureStorage
    }
    
    
    func testLocalStorageTestEncrypedManualKeys() throws {
        let privateKey = try secureStorage.retrievePrivateKey(forTag: "LocalStorageTests") ?? secureStorage.createKey("LocalStorageTests")
        guard let publicKey = try secureStorage.retrievePublicKey(forTag: "LocalStorageTests") else {
            throw XCTestFailure()
        }
        
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")
        
        try localStorage.store(letter, settings: .encryped(privateKey: privateKey, publicKey: publicKey))
        let storedLetter: Letter = try localStorage.read(settings: .encryped(privateKey: privateKey, publicKey: publicKey))
        
        try XCTAssertEqual(letter, storedLetter)
    }
    
    func testLocalStorageTestEncrypedKeychain() throws {
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")

        try localStorage.store(letter, settings: .encrypedUsingKeyChain())
        let storedLetter: Letter = try localStorage.read(settings: .encrypedUsingKeyChain())

        try XCTAssertEqual(letter, storedLetter)
    }

    func testLocalStorageTestEncrypedSecureEnclave() throws {
        let letter = Letter(greeting: "Hello Paul 👋\(String(repeating: "🚀", count: Int.random(in: 0...10)))")
        
        try localStorage.store(letter, settings: .encrypedUsingSecureEnclave())
        let storedLetter: Letter = try localStorage.read(settings: .encrypedUsingSecureEnclave())
        
        try XCTAssertEqual(letter, storedLetter)
    }
}
