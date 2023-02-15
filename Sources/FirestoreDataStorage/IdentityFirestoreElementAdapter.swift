//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


/// Provides an identity mapping of a type already conforming to ``FirestoreElement``/``FirestoreRemovalContext`` to the type-erased counterparts (``AnyFirestoreElement``/``AnyFirestoreRemovalContext``)
public actor DefaultFirestoreElementAdapter<InputElement: AnyFirestoreElement, InputRemovalContext: AnyFirestoreRemovalContext>: SingleValueAdapter {
    public typealias OutputElement = FirestoreElement
    public typealias OutputRemovalContext = FirestoreRemovalContext
    
    
    public init() {}
    
    
    public func transform(element: InputElement) throws -> FirestoreElement {
        FirestoreElement(
            id: element.id,
            collectionPath: element.collectionPath,
            element
        )
    }
    
    public func transform(removalContext: InputRemovalContext) throws -> FirestoreRemovalContext {
        FirestoreRemovalContext(
            id: removalContext.id,
            collectionPath: removalContext.collectionPath
        )
    }
}
