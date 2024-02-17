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
    typealias Value = [AnyHashable: Any]
#else // os(watchOS)
    typealias Value = [Never: Any]
#endif

    static let defaultValue: Value = [:]
}


extension Spezi {
#if os(iOS) || os(visionOS) || os(tvOS)
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any] {
        storage[LaunchOptionsKey.self]
    }
#elseif os(macOS)
    public var launchOptions: [AnyHashable: Any] {
        storage[LaunchOptionsKey.self]
    }
#else // os(watchOS)
    public var launchOptions: [Never: Any] {
        storage[LaunchOptionsKey.self]
    }
#endif
}
