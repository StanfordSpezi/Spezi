//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ObservableObjectComponentTests: TestAppUITests {
    func testLocalStorage() throws {
        try runTestAppUITests(feature: "ObservableObject", timeout: 0.1)
    }
}
