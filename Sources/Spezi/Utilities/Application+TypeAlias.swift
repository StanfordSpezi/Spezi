//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//



#if os(iOS) || os(visionOS) || os(tvOS)
public import class UIKit.UIApplication
/// Platform agnostic Application.
///
/// Type-alias for the `UIApplication`.
public typealias _Application = UIApplication // swiftlint:disable:this type_name
#elseif os(macOS)
public import class AppKit.UIApplication
/// Platform agnostic Application.
///
/// Type-alias for the `NSApplication`.
public typealias _Application = NSApplication // swiftlint:disable:this type_name
#elseif os(watchOS)
public import class WatchKit.WKApplication
/// Platform agnostic Application.
///
/// Type-alias for the `WKApplication`.
public typealias _Application = WKApplication // swiftlint:disable:this type_name

extension WKApplication {
    /// Allow the same access pattern for WKApplication. Bridges to the `shared()` method.
    @_documentation(visibility: internal)
    public static var shared: WKApplication {
        shared()
    }
}
#endif
