//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation


struct ModuleReferences: DefaultProvidingKnowledgeSource {
    static let defaultValue = ModuleReferences()

    typealias Anchor = SpeziAnchor

    private var references: [ModuleReference]

    init(_ references: [ModuleReference]) {
        self.references = references
    }
}


struct ModuleReference: Hashable { // TODO: move
    private let id: ObjectIdentifier

    init(_ module: any Module) {
        self.id = ObjectIdentifier(module)
    }
}


extension ModuleReferences: Collection {
    typealias Index = Array<ModuleReference>.Index

    var startIndex: Index {
        references.startIndex
    }

    var endIndex: Index {
        references.endIndex
    }

    func index(after index: Index) -> Index {
        references.index(after: index)
    }

    subscript(position: Index) -> ModuleReference {
        references[position]
    }
}


extension ModuleReferences: RangeReplaceableCollection {
    typealias SubSequence = Self

    
    init() {
        self.init([])
    }


    mutating func replaceSubrange<C: Collection>(_ subrange: Range<Self.Index>, with newElements: C) where Element == C.Element {
        references.replaceSubrange(subrange, with: newElements)
    }

    subscript(bounds: Range<Index>) -> ModuleReferences {
        let elements = references[bounds]
        return ModuleReferences(elements)
    }
}


extension ModuleReferences: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: ModuleReference...) {
        self.init(elements)
    }
}
