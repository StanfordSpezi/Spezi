//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR
import FirestoreDataStorage
import Foundation


/// <#Description#>
public struct FHIRFirestoreElement: FirestoreElement, @unchecked Sendable {
    let resource: Resource
    
    public let id: String
    public let collectionPath: String
    
    
    init(_ baseType: FHIR.BaseType) {
        self.resource = baseType
        self.id = baseType.id?.value?.string ?? UUID().uuidString
        self.collectionPath = ResourceProxy(with: baseType).resourceType
    }
    
    
    public func encode(to encoder: Encoder) throws {
        try resource.encode(to: encoder)
    }
}


/// <#Description#>
public struct FHIRFirestoreRemovalContext: FirestoreRemovalContext, @unchecked Sendable {
    public let id: String
    public let collectionPath: String
    
    
    init(_ removalContext: FHIR.RemovalContext) {
        self.id = removalContext.id?.value?.string ?? UUID().uuidString
        self.collectionPath = removalContext.resourceType.rawValue
    }
}


/// <#Description#>
public actor FHIRToFirestoreAdapter: SingleValueAdapter {
    public typealias InputElement = FHIR.BaseType
    public typealias InputRemovalContext = FHIR.RemovalContext
    public typealias OutputElement = FHIRFirestoreElement
    public typealias OutputRemovalContext = FHIRFirestoreRemovalContext
    
    
    public init() {}
    
    
    public func transform(element: InputElement) throws -> FHIRFirestoreElement {
        FHIRFirestoreElement(element)
    }
    
    public func transform(removalContext: InputRemovalContext) throws -> FHIRFirestoreRemovalContext {
        FHIRFirestoreRemovalContext(removalContext)
    }
}
