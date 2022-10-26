//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SecureStorage


final class SecureStorageTests {
    func testInternetCredentials() throws {
        let secureStorage = SecureStorage<UITestsAppStandard>()
        
        var serverCredentials = Credentials(username: "@PSchmiedmayer", password: "CardinalKitInventor")
        try secureStorage.store(credentials: serverCredentials, server: "twitter.com")
        
        let retrievedCredentials = try XCTUnwrap(secureStorage.retrieveCredentials("@PSchmiedmayer", server: "twitter.com"))
        try XCTAssertEqual(serverCredentials, retrievedCredentials)
        
        
        serverCredentials = Credentials(username: "@CardinalKit", password: "Paul")
        try secureStorage.updateCredentials("@PSchmiedmayer", newCredentials: serverCredentials, newServer: "stanford.edu")
        
        let retrievedUpdatedCredentials = try XCTUnwrap(secureStorage.retrieveCredentials("@PSchmiedmayer", server: "stanford.edu"))
        try XCTAssertEqual(serverCredentials, retrievedUpdatedCredentials)
        
        
        try secureStorage.deleteCredentials("@PSchmiedmayer", server: "stanford.edu")
        try XCTAssertNil(try secureStorage.retrieveCredentials("@PSchmiedmayer", server: "stanford.edu"))
    }
}
