//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR


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
