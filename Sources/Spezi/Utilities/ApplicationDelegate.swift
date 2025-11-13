//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(SwiftUI)
import SwiftUI


#if os(iOS) || os(visionOS) || os(tvOS)
typealias ApplicationDelegate = UIApplicationDelegate // swiftlint:disable:this file_types_order
#elseif os(macOS)
typealias ApplicationDelegate = NSApplicationDelegate
#elseif os(watchOS)
typealias ApplicationDelegate = WKApplicationDelegate
#endif
#endif
