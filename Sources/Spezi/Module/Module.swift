//
// This source file is part of the Stanford Spezi open-source project
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
/// - Automatic injection in the SwiftUI view hierarchy (``ObservableObjectProvider`` & `ObservableObject`)
///
/// All functionality provided to ``Component``s is also available to ``Module``s including dependencies using the @``Component/Dependency`` property wrapper.
///
/// Please take a look at the ``Component`` documentation for more information.
public typealias Module = Component & LifecycleHandler & ObservableObjectProvider & ObservableObject
