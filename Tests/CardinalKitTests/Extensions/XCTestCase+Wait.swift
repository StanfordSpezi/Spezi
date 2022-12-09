//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


extension XCTestCase {
    func wait(for testExpectations: [XCTestExpectation]) {
        wait(for: testExpectations, timeout: 0.01)
    }
}
