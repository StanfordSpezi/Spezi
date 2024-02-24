//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import SwiftUI


struct LaunchOptionsKey: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor

#if os(iOS) || os(visionOS) || os(tvOS)
    typealias Value = [UIApplication.LaunchOptionsKey: Any]
#elseif os(macOS)
    /// Currently not supported as ``SpeziAppDelegate/applicationWillFinishLaunching(_:)`` on macOS
    /// is executed after the initialization of ``Spezi`` via `View/spezi(_:)` is done, breaking our initialization assumption in ``SpeziAppDelegate/applicationWillFinishLaunching(_:)``.
    typealias Value = [Never: Any]
#else // os(watchOS)
    typealias Value = [Never: Any]
#endif

    static let defaultValue: Value = [:]
}


extension Spezi {
#if os(iOS) || os(visionOS) || os(tvOS)
    /// The launch options of the application.
    ///
    /// You can access the launch options within your `configure()` method of your ``Module`` or ``Standard``.
    ///
    /// - Note: For more information refer to the documentation of
    ///     [`application(_:willFinishLaunchingWithOptions:)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623032-application).
    ///
    /// Below is a short code example on how to access the launch options within your `Module`.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.launchOptions)
    ///     var launchOptions
    ///
    ///     func configure() {
    ///         // interact with your launchOptions upon application launch
    ///     }
    /// }
    /// ```
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any] {
        storage[LaunchOptionsKey.self]
    }
#else // os(watchOS) || os(macOS)
    /// The launch options of the application on platforms that don't support launch options.
    public var launchOptions: [Never: Any] {
        storage[LaunchOptionsKey.self]
    }
#endif
}
