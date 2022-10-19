//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
//
// This code is based on the Apodini (https://github.com/Apodini/Apodini) project.
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the Apodini project authors
//
// SPDX-License-Identifier: MIT
//

struct TupleConfiguration<S: Standard>: StandardBasedConfiguration {
    typealias ResourceRepresentation = S
    
    let first: (any StandardBasedConfiguration)?
    let second: (any StandardBasedConfiguration)?
    
    
    init<C0: StandardBasedConfiguration, C1: StandardBasedConfiguration>(
        _ first: C0,
        _ second: C1
    ) where C0.ResourceRepresentation == C1.ResourceRepresentation, C0.ResourceRepresentation == S {
        self.first = first
        self.second = second
    }
    
    init<C: StandardBasedConfiguration>(_ first: C) where C.ResourceRepresentation == S {
        self.first = first
        self.second = nil
    }
    
    init() {
        self.first = nil
        self.second = nil
    }
    
    
    func configure<S: Standard>(_ cardinalKit: CardinalKit<S>) {
        first?.configure(cardinalKit)
        second?.configure(cardinalKit)
    }
}


/// An empty ``Configuration``.
struct EmptyConfiguration<S: Standard>: StandardBasedConfiguration {
    typealias ResourceRepresentation = S
    
    
    func configure<S: Standard>(_ cardinalKit: CardinalKit<S>) { }
}
