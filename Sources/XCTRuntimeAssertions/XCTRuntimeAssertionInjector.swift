//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG
import Foundation


class XCTRuntimeAssertionInjector {
    static var injected = XCTRuntimeAssertionInjector(id: UUID())
    
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
    
    static func reset() {
        injected = XCTRuntimeAssertionInjector(id: UUID())
    }
    
    
    func assert(_ condition: () -> Bool, message: () -> String, file: StaticString, line: UInt) {
        self._assert(id, condition, message, file, line)
    }
    
    func precondition(_ condition: () -> Bool, message: () -> String, file: StaticString, line: UInt) {
        self._precondition(id, condition, message, file, line)
    }
}
#endif
