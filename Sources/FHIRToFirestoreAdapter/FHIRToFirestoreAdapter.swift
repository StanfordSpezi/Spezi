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


/// Adapts the output of the `FHIR` standard to be used with the `Firestore` data storage provider.
///
/// Use the ``FHIRToFirestoreAdapter`` in the adapter result builder of the `Firestore` data storage provider in the CardinalKit `Configuration`.
/// ```swift
/// class ExampleAppDelegate: CardinalKitAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             Firestore {
///                 FHIRToFirestoreAdapter()
///             }
///             // ...
///         }
///     }
/// }
/// ```
public actor FHIRToFirestoreAdapter: SingleValueAdapter {
    public typealias InputElement = FHIR.BaseType
    public typealias InputRemovalContext = FHIR.RemovalContext
    public typealias OutputElement = FirestoreElement
    public typealias OutputRemovalContext = FirestoreRemovalContext
    
    
    public init() {}
    
    
    public func transform(element: InputElement) throws -> FirestoreElement {
        FirestoreElement(
            id: element.id?.value?.string ?? UUID().uuidString,
            collectionPath: ResourceProxy(with: element).resourceType,
            element
        )
    }
    
    public func transform(removalContext: InputRemovalContext) throws -> FirestoreRemovalContext {
        FirestoreRemovalContext(
            id: removalContext.id?.value?.string ?? UUID().uuidString,
            collectionPath: removalContext.resourceType.rawValue
        )
    }
}
