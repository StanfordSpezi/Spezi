//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG
class XCTRuntimeAssertionInjector {
    static var injected = XCTRuntimeAssertionInjector()
    
    
    let assert: (() -> Bool, () -> String, StaticString, UInt) -> Void
    let precondition: (() -> Bool, () -> String, StaticString, UInt) -> Void
    
    
    init(
        assert: @escaping (() -> Bool, () -> String, StaticString, UInt) -> Void = Swift.assert,
        precondition: @escaping (() -> Bool, () -> String, StaticString, UInt) -> Void = Swift.precondition
    ) {
        self.assert = assert
        self.precondition = precondition
    }
    
    
    static func reset() {
        injected = XCTRuntimeAssertionInjector()
    }
}
#endif
