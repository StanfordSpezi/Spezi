//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation
import SwiftUI


@_spi(Spezi)
public struct LaunchOptionsKey: DefaultProvidingKnowledgeSource {
    public typealias Anchor = SpeziAnchor

#if os(iOS) || os(visionOS) || os(tvOS)
    public typealias Value = [UIApplication.LaunchOptionsKey: Any]
#elseif os(macOS)
    /// Currently not supported as ``SpeziAppDelegate/applicationWillFinishLaunching(_:)`` on macOS
    /// is executed after the initialization of ``Spezi/Spezi`` via `View/spezi(_:)` is done, breaking our initialization assumption in ``SpeziAppDelegate/applicationWillFinishLaunching(_:)``.
    public typealias Value = [Never: Any]
#else // os(watchOS)
    public typealias Value = [Never: Any]
#endif

    // Unsafe, non-isolated is fine as we have an empty dictionary.
    // We inherit the type from UIKit, Any is inherently unsafe and also contains objects which might not conform to sendable.
    // Dealing with launch options in a safe way is up to the implementing Module to do so. Ideally we would make
    // `Application/launchOptions` to be isolated to the MainActor. However, we can't really do that selectively with the @Application
    // property wrapper. Most likely, you would interact with launch options in the `configure()` method which is @MainActor isolated.
    public static nonisolated(unsafe) let defaultValue: Value = [:]
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
