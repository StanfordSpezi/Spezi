//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class SecureStorageTests: TestAppUITests {
    func testLocalStorage() throws {
        try runTestAppUITests(feature: "SecureStorage", timeout: 0.2)
    }
}
