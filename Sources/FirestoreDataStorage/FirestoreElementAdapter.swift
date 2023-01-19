//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


/// An adapter that a type conforms to when transforming elements and removal contexts for the ``Firestore`` data storage provider.
///
/// Transforms an input element to a ``FirestoreElement`` and a removal context to a ``FirestoreRemovalContext``.
public protocol FirestoreElementAdapter<
    InputElement,
    InputRemovalContext
>: SingleValueAdapter where OutputElement: FirestoreElement, OutputRemovalContext: FirestoreRemovalContext { }
