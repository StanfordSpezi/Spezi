//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi


extension Array where Element == any Module {
    func moduleOfType<M: Module>(_ moduleType: M.Type = M.self, expectedNumber: Int = 1) throws -> M {
        let typedModules = compactMap { $0 as? M }
        XCTAssertEqual(typedModules.count, expectedNumber)
        return try XCTUnwrap(typedModules.first)
    }
}
