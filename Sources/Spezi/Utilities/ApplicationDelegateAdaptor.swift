//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


#if os(iOS) || os(visionOS) || os(tvOS)
/// Platform agnostic ApplicationDelegateAdaptor.
///
/// Type-alias for the `UIApplicationDelegateAdaptor`.
public typealias ApplicationDelegateAdaptor = UIApplicationDelegateAdaptor // swiftlint:disable:this file_types_order
#elseif os(macOS)
/// Platform agnostic ApplicationDelegateAdaptor.
///
/// Type-alias for the `NSApplicationDelegateAdaptor`.
public typealias ApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
#elseif os(watchOS)
/// Platform agnostic ApplicationDelegateAdaptor.
///
/// Type-alias for the `WKApplicationDelegateAdaptor`.
public typealias ApplicationDelegateAdaptor = WKApplicationDelegateAdaptor
#endif
