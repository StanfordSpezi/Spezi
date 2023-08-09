//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``KnowledgeSource`` that provides a default value.
public protocol DefaultProvidingKnowledgeSource<Anchor>: KnowledgeSource {
    /// The provided default value.
    ///
    /// A default value must stay consistent and must not change.
    static var defaultValue: Value { get }
}
