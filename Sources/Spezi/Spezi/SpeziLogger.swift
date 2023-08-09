//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os

struct SpeziLogger: ComputedKnowledgeSource {
    typealias Anchor = SpeziAnchor
    typealias StoragePolicy = Store
    
    typealias Value = Logger

    
    static func compute<Repository: SharedRepository<Anchor>>(from repository: Repository) -> Logger {
        Logger(subsystem: "edu.stanford.spezi", category: "spezi")
    }
}
