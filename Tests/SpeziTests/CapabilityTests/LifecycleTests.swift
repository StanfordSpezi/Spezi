//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(SwiftUI)
@testable import Spezi
import SwiftUI
import Testing


@available(*, deprecated, message: "Propagate deprecation warning")
private final class TestLifecycleHandler: Module, LifecycleHandler {
    var willFinishLaunchingWithOptionConfirmation: Confirmation? // swiftlint:disable:this identifier_name
    var willTerminateConfirmation: Confirmation?

    @Application(\.launchOptions)
    var launchOptions

    
    init() {}
    
#if os(iOS) || os(visionOS) || os(tvOS)
    func willFinishLaunchingWithOptions(
        _ application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]
    ) {
        willFinishLaunchingWithOptionConfirmation?()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        willTerminateConfirmation?()
    }
#endif
}


@available(*, deprecated, message: "Propagate deprecation warning")
private final class EmptyLifecycleHandler: Module, LifecycleHandler { }

@available(*, deprecated, message: "Propagate deprecation warning")
private class TestLifecycleHandlerApplicationDelegate: SpeziAppDelegate {
    private let injectedModule: TestLifecycleHandler
    
    
    override var configuration: Configuration {
        Configuration {
            injectedModule
            EmptyLifecycleHandler()
        }
    }

    init(injectedModule: TestLifecycleHandler) {
        self.injectedModule = injectedModule
    }
}


@Suite("Lifecycle", .serialized)
struct LifecycleTests {
    @MainActor
    @available(*, deprecated, message: "Propagate deprecation warning")
    @Test("UIApplication Lifecycle Methods")
    func testUIApplicationLifecycleMethods() async throws {
        let module = TestLifecycleHandler()
        let testApplicationDelegate = TestLifecycleHandlerApplicationDelegate(injectedModule: module)


        #if os(iOS) || os(visionOS) || os(tvOS)
        let launchOptions = try [UIApplication.LaunchOptionsKey.url: #require(URL(string: "spezi.stanford.edu"))]
        await confirmation { confirmation in
            module.willFinishLaunchingWithOptionConfirmation = confirmation

            let willFinishLaunchingWithOptions = testApplicationDelegate.application(
                UIApplication.shared,
                willFinishLaunchingWithOptions: launchOptions
            )
            #expect(willFinishLaunchingWithOptions)
            module.willFinishLaunchingWithOptionConfirmation = nil
        }

        #expect(module.launchOptions.keys.allSatisfy { launchOptions[$0] != nil })
        #elseif os(macOS)
        let launchOptions: [AnyHashable: Any] = [UUID(): "Some value"]
        testApplicationDelegate.applicationWillFinishLaunching(
            Notification(name: NSApplication.willFinishLaunchingNotification, userInfo: launchOptions)
        )

        #expect(module.launchOptions.keys.allSatisfy { launchOptions[$0] != nil })
        #elseif os(watchOS)
        testApplicationDelegate.applicationDidFinishLaunching()
        #endif

        #if os(iOS) || os(visionOS) || os(tvOS)
        await confirmation { confirmation in
            module.willTerminateConfirmation = confirmation
            testApplicationDelegate.applicationWillTerminate(UIApplication.shared)
            module.willTerminateConfirmation = nil
        }
        #endif
    }
}
#endif
