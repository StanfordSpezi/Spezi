//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import SecureStorage
import XCTCardinalKit


final class DependencyBuilderTests: XCTestCase {
    func testSecureStorageCredentials() {
        let secureStorage = SecureStorage<MockStandard>()
    }
}
