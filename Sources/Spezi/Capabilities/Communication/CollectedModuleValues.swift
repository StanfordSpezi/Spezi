//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import OrderedCollections
import SpeziFoundation


struct CollectedModuleValues<ModuleValue>: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor
    typealias Value = OrderedDictionary<UUID, [ModuleValue]>

    static var defaultValue: Value {
        [:]
    }
}
