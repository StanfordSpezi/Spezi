//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

struct XCTestFailure: Error, CustomStringConvertible {
    let file: StaticString
    let line: Int
    
    
    var description: String {
        "XCTestFailure in \(file) at line \(line)"
    }
    
    
    init(file: StaticString = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }
}


func XCTAssert(_ condition: @autoclosure () -> Bool, file: StaticString = #file, line: Int = #line) throws {
    guard condition() else {
        throw XCTestFailure(file: file, line: line)
    }
}

func XCTAssertEqual<E: Equatable>(_ lhs: E, _ rhs: E, file: StaticString = #file, line: Int = #line) throws {
    guard lhs == rhs else {
        throw XCTestFailure(file: file, line: line)
    }
}


func XCTAssertNil<O>(_ optional: O?, file: StaticString = #file, line: Int = #line) throws {
    guard optional == nil else {
        throw XCTestFailure(file: file, line: line)
    }
}

func XCTUnwrap<O>(_ optional: O?, file: StaticString = #file, line: Int = #line) throws -> O {
    guard let unwrapped = optional else {
        throw XCTestFailure(file: file, line: line)
    }
    return unwrapped
}
