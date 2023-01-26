//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A sophisticated ``Component`` with several built-in functionality.
///
/// A ``Module`` is a ``Component`` that also includes
/// - Conformance to a ``LifecycleHandler``
/// - Persistance in the ``CardinalKit`` instance's ``CardinalKit/CardinalKit/typedCollection`` (using a conformance to ``TypedCollectionKey``)
/// - Automatic injection in the SwiftUI view hierachy (``ObservableObjectProvider`` & `ObservableObject`)
///
/// All functionality provided to ``Component``s is also available to ``Module``s including dependencies using the @``Component/Dependency`` property wrapper.
///
/// Please take a look at the ``Component`` documentation for more information.
public typealias Module = Component & LifecycleHandler & ObservableObjectProvider & ObservableObject & TypedCollectionKey
