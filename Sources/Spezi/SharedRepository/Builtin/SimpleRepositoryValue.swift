//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// A simple implementation of a ``RepositoryValue``.
public struct SimpleRepositoryValue<Source: KnowledgeSource>: RepositoryValue {
    public let value: Source.Value


    public init(_ value: Source.Value) {
        self.value = value
    }
}


extension SimpleRepositoryValue: Sendable where Source.Value: Sendable {}
