//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``Module`` is a larger ``Component`` that is a ``LifecycleHandler``, persisted in the ``CardinalKit`` instance's ``CardinalKit/CardinalKit/storage`` (using a conformance to ``StorageKey``), and injected in the SwiftUI view hierachy (``ObservableObjectComponent`` & ``ObservableObject``).
public typealias Module = Component & LifecycleHandler & ObservableObjectComponent & ObservableObject & StorageKey
