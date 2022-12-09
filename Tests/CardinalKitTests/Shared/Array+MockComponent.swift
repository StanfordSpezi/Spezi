//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


extension Array where Element == any Component<MockStandard> {
    func componentOfType<C: Component>(_ componentType: C.Type = C.self, expectedNumber: Int = 1) throws -> C {
        let typedComponents = compactMap { $0 as? C }
        XCTAssertEqual(typedComponents.count, expectedNumber)
        return try XCTUnwrap(typedComponents.first)
    }
}
