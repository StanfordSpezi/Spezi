//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A protocol representing a knowledge anchor for a ``SharedRepository`` implementation.
///
/// The ``RepositoryAnchor`` defines the requirements for an anchor that is associated with a specific
/// ``SharedRepository`` implementation.  It servers as a reference point within ``KnowledgeSource``s, allowing for scoping
/// and organizing the available information.
///
/// - Note: If you desire a `Sendable` ``SharedRepository``, adopt the `Sendable` protocol for your ``RepositoryAnchor``
///     to signal that requirement to implementors. This is however not enforced.
public protocol RepositoryAnchor {}
