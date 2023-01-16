//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides an identity mapping of a type already conforming to ``FirestoreElement``/``FirestoreRemovalContext`` to the type-erased counterparts (``AnyFirestoreElement``/``AnyFirestoreRemovalContext``)
public actor DefaultFirestoreElementAdapter<InputElement: FirestoreElement, InputRemovalContext: FirestoreRemovalContext>: FirestoreElementAdapter {
    public typealias OutputElement = AnyFirestoreElement
    public typealias OutputRemovalContext = AnyFirestoreRemovalContext
    
    
    /// Type-erased version of a ``FirestoreElement`` instance.
    public struct AnyFirestoreElement: FirestoreElement {
        fileprivate let element: any FirestoreElement
        
        
        public var collectionPath: String {
            element.collectionPath
        }
        public var id: String {
            element.id
        }
        
        
        fileprivate init(element: some FirestoreElement) {
            self.element = element
        }
        
        
        public func encode(to encoder: Encoder) throws {
            try element.encode(to: encoder)
        }
    }
    
    /// Type-erased version of a ``FirestoreRemovalContext`` instance.
    public struct AnyFirestoreRemovalContext: FirestoreRemovalContext {
        public let collectionPath: String
        public let id: String
        
        
        fileprivate init(collectionPath: String, id: String) {
            self.collectionPath = collectionPath
            self.id = id
        }
    }
    
    
    public init() {}
    
    
    public func transform(element: InputElement) -> AnyFirestoreElement {
        AnyFirestoreElement(element: element)
    }
    
    public func transform(removalContext: InputRemovalContext) -> AnyFirestoreRemovalContext {
        AnyFirestoreRemovalContext(collectionPath: removalContext.collectionPath, id: removalContext.id)
    }
}
