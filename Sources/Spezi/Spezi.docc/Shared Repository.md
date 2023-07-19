# Shared Repository

<!--
                  
This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

A common interface for a storage mechanism that allows multiple entities to access, provide and modify shared data.

## Overview

A Shared Repository is a software pattern that allows to easily integrate application functionality with
a data-driven control flow or applications that operate on the same data, but do not share the same processing
workflow or are split across multiple software systems.

This implementation is a modified version of the Shared Repository as described by
Buschmann et al. in _Pattern-Oriented Software Architecture: A Pattern Language for Distributed Computing_.

A ``SharedRepository`` acts as a typed collection. Stored data is defined and keyed by ``KnowledgeSource`` instances.
You can constrain the applicable ``KnowledgeSource``s by defining a ``RepositoryAnchor``

### Default Implementations

Spezi provide two default implementations for the ``SharedRepository`` protocol:
* ``HeapRepository``: A Shared Repository that itself is a reference type. This is useful to easily pass around a single instance of
    a shared repository by reference.
* ``ValueRepository``: A Shared Repository that itself is a value type. This mimics behavior of Swift's `Array` or `Dictionary` types. It is useful
    in cases where you want to restrict mutability of the Shared Repository based on the properties mutability (`var` vs. `let`).

### Sendable

A Shared Repository is not `Sendable` by default and completely depends on the implementation.
The ``ValueRepository`` adds `Sendable` conformance if the ``RepositoryAnchor`` adopts the `Sendable` protocol.
This signifies to ``KnowledgeSource`` adopters, that their ``KnowledgeSource/Value`` type should be made `Sendable`.

> Warning: Due to Swift limitations, the ``ValueRepository`` implementation never checks if a given ``KnowledgeSource`` implementation actually has
    a value type that conforms to `Sendable`. Therefore, implementors should make sure that their ``KnowledgeSource/Value`` conforms to `Sendable`.
    If you require to check for such a conformance, you may write a Wrapper around the ``ValueRepository``, replicating its interface.

## Topics

### Shared Repository

- ``Spezi/SharedRepository``

### Knowledge Sources

- ``Spezi/KnowledgeSource``
- ``Spezi/DefaultProvidingKnowledgeSource``
- ``Spezi/ComputedKnowledgeSource``
- ``Spezi/OptionalComputedKnowledgeSource``

### Builtin Implementations

- ``Spezi/HeapRepository``
- ``Spezi/ValueRepository``
- ``Spezi/UniversalHeapRepository``
- ``Spezi/UniversalValueRepository``

### Implementing a Shared Repository

- ``Spezi/RepositoryAnchor``
- ``Spezi/RepositoryValue``
- ``Spezi/AnyRepositoryValue``
- ``Spezi/SimpleRepositoryValue``
