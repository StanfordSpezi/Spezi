//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


// TODO docs
public struct SpeziAnchor: RepositoryAnchor {}


// TODO move to specific file
extension Component {
    func storeComponent<Repository: SharedRepository<SpeziAnchor>>(into repository: inout Repository) {
        guard let value = self as? Value else {
            // TODO print warning, can't store component as it was modified!
            return
        }
        repository[Self.self] = value
    }
}


/// Previously defined a key used to identify stored elements in type collection.
/// The underlying infrastructure was removed and replaced by the ``SharedRepository`` and ``KnowledgeSource`` abstraction.
@available(*, deprecated, message: "TypedCollectionKey protocol should be replaced by adopting the KnowledgeSource<SpeziAnchor> protocol. However, this is done automatically.")
public protocol TypedCollectionKey: KnowledgeSource<SpeziAnchor> {} // TODO remove altogether?
