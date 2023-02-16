//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG || TEST
import Foundation


/// `XCTRuntimePrecondition` allows you to test assertions of types that use the `precondition` and `preconditionFailure` functions of the `XCTRuntimeAssertions` target.
/// - Parameters:
///   - validateRuntimeAssertion: An optional closure that can be used to furhter validate the messages passed to the
///                               `precondition` and `preconditionFailure` functions of the `XCTRuntimeAssertions` target.
///   - timeout: A timeout defining how long to wait for the precondition to be triggered.
///   - message: A message that is posted on failure.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - expression: The expression that is evaluated.
/// - Throws: Throws an `XCTFail` error if the expection does not trigger a runtime assertion with the parameters defined above.
public func XCTRuntimePrecondition(
    validateRuntimeAssertion: ((String) -> Void)? = nil,
    timeout: Double = 0.01,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ expression: @escaping () throws -> Void
) throws {
    let xctRuntimeAssertionId = UUID()
    // We have to run the operation on a `DispatchQueue` as we have to call `RunLoop.current.run()` in the `preconditionFailure` call.
    let dispatchQueue = DispatchQueue(label: "XCTRuntimePrecondition-\(xctRuntimeAssertionId)")
    var fulfillmentCount: Int = 0
    
    XCTRuntimeAssertionInjector.inject(
        runtimeAssertionInjector: XCTRuntimeAssertionInjector(
            id: xctRuntimeAssertionId,
            precondition: { id, condition, message, _, _  in
                guard id == xctRuntimeAssertionId else {
                    return
                }
                
                if condition() {
                    // We execute the message closure independent of the availability of the `validateRuntimeAssertion` closure.
                    let message = message()
                    validateRuntimeAssertion?(message)
                    fulfillmentCount += 1
                    neverReturn()
                }
            }
        )
    )
    
    let expressionWorkItem = DispatchWorkItem {
        do {
            try expression()
        } catch {}
    }
    dispatchQueue.async(execute: expressionWorkItem)
    
    // We don't use:
    // `wait(for: [expectation], timeout: timeout)`
    // here as we need to make the method independent of XCTestCase to also use it in our TestApp UITest target which fails if you import XCTest.
    usleep(useconds_t(1_000_000 * timeout))
    expressionWorkItem.cancel()
    
    if fulfillmentCount != 1 {
        throw XCTFail(
            message: """
            The precondition was called multiple times.
            \(message()) at \(file):\(line)
            """
        )
    }
    
    XCTRuntimeAssertionInjector.removeRuntimeAssertionInjector(withId: xctRuntimeAssertionId)
}

private func neverReturn() -> Never {
    // This is unfortunate but as far as I can see the only feasable way to return Never without calling a runtime crashing function, e.g. `fatalError()`.
    repeat {
        RunLoop.current.run()
    } while (true)
}

/// Checks a necessary condition for making forward progress.
///
/// Use this function to detect conditions that must prevent the program from
/// proceeding, even in shipping code.
///
/// * In playgrounds and `-Onone` builds (the default for Xcode's Debug
///   configuration): If `condition` evaluates to `false`, stop program
///   execution in a debuggable state after printing `message`.
///
/// * In `-O` builds (the default for Xcode's Release configuration): If
///   `condition` evaluates to `false`, stop program execution.
///
/// * In `-Ounchecked` builds, `condition` is not evaluated, but the optimizer
///   may assume that it *always* evaluates to `true`. Failure to satisfy that
///   assumption is a serious programming error.
///
/// - Parameters:
///   - condition: The condition to test. `condition` is not evaluated in
///     `-Ounchecked` builds.
///   - message: A string to print if `condition` is evaluated to `false` in a
///     playground or `-Onone` build. The default is an empty string.
///   - file: The file name to print with `message` if the precondition fails.
///     The default is the file where `precondition(_:_:file:line:)` is
///     called.
///   - line: The line number to print along with `message` if the assertion
///     fails. The default is the line number where
///     `precondition(_:_:file:line:)` is called.
public func precondition(
    _ condition: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = String(),
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTRuntimeAssertionInjector.precondition(condition, message: message, file: file, line: line)
}

/// Indicates that a precondition was violated.
///
/// Use this function to stop the program when control flow can only reach the
/// call if your API was improperly used and execution flow is not expected to
/// reach the call---for example, in the `default` case of a `switch` where
/// you have knowledge that one of the other cases must be satisfied.
///
/// This function's effect varies depending on the build flag used:
///
/// * In playgrounds and `-Onone` builds (the default for Xcode's Debug
///   configuration), stops program execution in a debuggable state after
///   printing `message`.
///
/// * In `-O` builds (the default for Xcode's Release configuration), stops
///   program execution.
///
/// * In `-Ounchecked` builds, the optimizer may assume that this function is
///   never called. Failure to satisfy that assumption is a serious
///   programming error.
///
/// - Parameters:
///   - message: A string to print in a playground or `-Onone` build. The
///     default is an empty string.
///   - file: The file name to print with `message`. The default is the file
///     where `preconditionFailure(_:file:line:)` is called.
///   - line: The line number to print along with `message`. The default is the
///     line number where `preconditionFailure(_:file:line:)` is called.
public func preconditionFailure(
    _ message: @autoclosure () -> String = String(),
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    XCTRuntimeAssertionInjector.precondition({ true }, message: message, file: file, line: line)
    neverReturn()
}
#endif
