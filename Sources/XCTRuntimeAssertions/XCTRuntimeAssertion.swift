//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG || TEST
import Foundation


/// `XCTRuntimeAssertion` allows you to test assertions of types that use the `assert` and `assertionFailure` functions of the `XCTRuntimeAssertions` target.
/// - Parameters:
///   - validateRuntimeAssertion: An optional closure that can be used to furhter validate the messages passed to the
///                               `assert` and `assertionFailure` functions of the `XCTRuntimeAssertions` target.
///   - expectedFulfillmentCount: The expected fulfillment count on how often the `assert` and `assertionFailure` functions of
///                               the `XCTRuntimeAssertions` target are called. The defailt value is 1.
///   - message: A message that is posted on failure.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - expression: The expression that is evaluated.
/// - Throws: Throws an `XCTFail` error if the expection does not trigger a runtime assertion with the parameters defined above.
/// - Returns: The value of the function if it did not throw an error as it did not trigger a runtime assertion with the parameters defined above.
public func XCTRuntimeAssertion<T>(
    validateRuntimeAssertion: ((String) -> Void)? = nil,
    expectedFulfillmentCount: Int = 1,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ expression: @escaping () throws -> T
) throws -> T {
    var fulfillmentCount: Int = 0
    let xctRuntimeAssertionId = UUID()
    
    XCTRuntimeAssertionInjector.inject(
        runtimeAssertionInjector: XCTRuntimeAssertionInjector(
            id: xctRuntimeAssertionId,
            assert: { id, condition, message, _, _  in
                guard id == xctRuntimeAssertionId else {
                    return
                }
                
                if condition() {
                    // We execute the message closure independent of the availability of the `validateRuntimeAssertion` closure.
                    let message = message()
                    validateRuntimeAssertion?(message)
                    fulfillmentCount += 1
                }
            }
        )
    )
    
    var result: Result<T, Error>
    do {
        result = .success(try expression())
    } catch {
        result = .failure(error)
    }
    
    XCTRuntimeAssertionInjector.removeRuntimeAssertionInjector(withId: xctRuntimeAssertionId)
    
    if fulfillmentCount != expectedFulfillmentCount {
        throw XCTFail(
            message: """
            Measured an fulfillment count of \(fulfillmentCount), expected \(expectedFulfillmentCount).
            \(message()) at \(file):\(line)
            """
        )
    }
    
    switch result {
    case let .success(returnValue):
        return returnValue
    case let .failure(error):
        throw error
    }
}


/// Performs a traditional C-style assert with an optional message.
///
/// Use this function for internal sanity checks that are active during testing
/// but do not impact performance of shipping code. To check for invalid usage
/// in Release builds, see `precondition(_:_:file:line:)`.
///
/// * In playgrounds and `-Onone` builds (the default for Xcode's Debug
///   configuration): If `condition` evaluates to `false`, stop program
///   execution in a debuggable state after printing `message`.
///
/// * In `-O` builds (the default for Xcode's Release configuration),
///   `condition` is not evaluated, and there are no effects.
///
/// * In `-Ounchecked` builds, `condition` is not evaluated, but the optimizer
///   may assume that it *always* evaluates to `true`. Failure to satisfy that
///   assumption is a serious programming error.
///
/// - Parameters:
///   - condition: The condition to test. `condition` is only evaluated in
///     playgrounds and `-Onone` builds.
///   - message: A string to print if `condition` is evaluated to `false`. The
///     default is an empty string.
///   - file: The file name to print with `message` if the assertion fails. The
///     default is the file where `assert(_:_:file:line:)` is called.
///   - line: The line number to print along with `message` if the assertion
///     fails. The default is the line number where `assert(_:_:file:line:)`
///     is called.
public func assert(
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = String(),
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTRuntimeAssertionInjector.assert(condition, message: message, file: file, line: line)
}

/// Indicates that an internal sanity check failed.
///
/// This function's effect varies depending on the build flag used:
///
/// * In playgrounds and `-Onone` builds (the default for Xcode's Debug
///   configuration), stop program execution in a debuggable state after
///   printing `message`.
///
/// * In `-O` builds, has no effect.
///
/// * In `-Ounchecked` builds, the optimizer may assume that this function is
///   never called. Failure to satisfy that assumption is a serious
///   programming error.
///
/// - Parameters:
///   - message: A string to print in a playground or `-Onone` build. The
///     default is an empty string.
///   - file: The file name to print with `message`. The default is the file
///     where `assertionFailure(_:file:line:)` is called.
///   - line: The line number to print along with `message`. The default is the
///     line number where `assertionFailure(_:file:line:)` is called.
public func assertionFailure(
    _ message: @autoclosure () -> String = String(),
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTRuntimeAssertionInjector.assert({ true }, message: message, file: file, line: line)
}
#endif
