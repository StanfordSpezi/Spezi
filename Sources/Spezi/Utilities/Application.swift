//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


#if os(iOS) || os(visionOS) || os(tvOS)
/// Platform agnostic Application.
///
/// Type-alias for the `UIApplication`.
public typealias _Application = UIApplication // swiftlint:disable:this type_name
#elseif os(macOS)
/// Platform agnostic Application.
///
/// Type-alias for the `NSApplication`.
public typealias _Application = NSApplication // swiftlint:disable:this type_name
#elseif os(watchOS)
/// Platform agnostic Application.
///
/// Type-alias for the `WKApplication`.
public typealias _Application = WKApplication // swiftlint:disable:this type_name
#endif
