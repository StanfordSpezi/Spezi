//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG || TEST
import Foundation


class XCTRuntimeAssertionInjector {
    private static var injected: [XCTRuntimeAssertionInjector] = []
    
    
    let id: UUID
    private let _assert: (UUID, () -> Bool, () -> String, StaticString, UInt) -> Void
    private let _precondition: (UUID, () -> Bool, () -> String, StaticString, UInt) -> Void
    
    
    init(
        id: UUID,
        assert: @escaping (UUID, () -> Bool, () -> String, StaticString, UInt) -> Void,
        precondition: @escaping (UUID, () -> Bool, () -> String, StaticString, UInt) -> Void
    ) {
        self.id = id
        self._assert = assert
        self._precondition = precondition
    }
    
    init(
        id: UUID,
        assert: @escaping (UUID, () -> Bool, () -> String, StaticString, UInt) -> Void
    ) {
        self.id = id
        self._assert = assert
        self._precondition = { _, condition, messsage, file, line in
            Swift.precondition(condition(), messsage(), file: file, line: line)
        }
    }
    
    init(
        id: UUID,
        precondition: @escaping (UUID, () -> Bool, () -> String, StaticString, UInt) -> Void
    ) {
        self.id = id
        self._assert = { _, condition, messsage, file, line in
            Swift.assert(condition(), messsage(), file: file, line: line)
        }
        self._precondition = precondition
    }
    
    init(
        id: UUID
    ) {
        self.id = id
        self._assert = { _, condition, messsage, file, line in
            Swift.assert(condition(), messsage(), file: file, line: line)
        }
        self._precondition = { _, condition, messsage, file, line in
            Swift.precondition(condition(), messsage(), file: file, line: line)
        }
    }
    
    
    static func inject(runtimeAssertionInjector: XCTRuntimeAssertionInjector) {
        injected.append(runtimeAssertionInjector)
    }
    
    static func removeRuntimeAssertionInjector(withId id: UUID) {
        injected.removeAll(where: { $0.id == id })
    }
    
    
    static func assert(_ condition: () -> Bool, message: () -> String, file: StaticString, line: UInt) {
        for runtimeAssertionInjector in injected {
            runtimeAssertionInjector._assert(runtimeAssertionInjector.id, condition, message, file, line)
        }
    }
    
    static func precondition(_ condition: () -> Bool, message: () -> String, file: StaticString, line: UInt) {
        for runtimeAssertionInjector in injected {
            runtimeAssertionInjector._precondition(runtimeAssertionInjector.id, condition, message, file, line)
        }
    }
}
#endif
