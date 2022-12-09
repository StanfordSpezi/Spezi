//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class LocalStorageTests: TestAppUITests {
    func testLocalStorage() throws {
        try runTestAppUITests(feature: "LocalStorage", timeout: 3)
    }
}
