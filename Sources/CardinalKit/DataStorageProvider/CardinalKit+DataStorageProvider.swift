//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension CardinalKit {
    nonisolated var dataStorageProviders: [any DataStorageProvider<S>] {
        typedCollection.get(allThatConformTo: (any DataStorageProvider<S>).self)
    }
}
