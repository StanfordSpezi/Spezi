//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation
@_exported @preconcurrency import ModelsR4
import XCTRuntimeAssertions


/// The ``FHIR/FHIR`` standard provides a CardinalKit `Standard` that utilizes HL7® FHIR® as the central standard for your CardinalKit application.
///
///
/// If you import the FHIR module using `import FHIR` you can specify all FHIR compatible components and modules in the configuration builder:
/// ```swift
/// import FHIR
/// import CardinalKit
///
/// public class ExampleCardinalKitAppDelegate: CardinalKitAppDelegate {
///     override public var configuration: Configuration {
///         Configuration {
///             FHIRComponentExample()
///         }
///     }
/// }
/// ```
///
/// You can also manually specify the FHIR Standard by passing it into the `configuration` initializer:
/// ```swift
/// import FHIR
/// import CardinalKit
///
/// public class ExampleCardinalKitAppDelegate: CardinalKitAppDelegate {
///     override public var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             FHIRComponentExample()
///         }
///     }
/// }
/// ```
public actor FHIR: Standard {
    /// The FHIR `Resource` type builds the `BaseType` of the ``FHIR/FHIR`` standard.
    public typealias BaseType = Resource
    /// The FHIR ``FHIRRemovalContext`` type builds the `RemovalContext` of the ``FHIR/FHIR`` standard.
    public typealias RemovalContext = FHIRRemovalContext
    
    
    /// Defines the nescessary context to process removals of a FHIR `Resource`.
    public struct FHIRRemovalContext: Sendable, Identifiable {
        /// The identifier of the FHIR `Resource`.
        public let id: BaseType.ID
        /// The string representation of the resource type of the FHIR `Resource`.
        ///
        /// You can obtain the resource type using a `ResourceProxy`:
        /// ```swift
        /// let resource: Resource = // ...
        /// let resourceProxy = ResourceProxy(with: resource)
        /// let resourceType = resourceProxy.resourceType
        /// ```
        /// or shortly:
        /// ```swift
        /// let resourceType = ResourceProxy(with: resource).resourceType
        /// ```
        public let resourceType: String
        
        
        /// - Parameters:
        ///   - id: The identifier of the FHIR `Resource`.
        ///   - resourceType: The string representation of the resource type of the FHIR `Resource`.
        ///
        /// You can obtain the resource type using a `ResourceProxy`:
        /// ```swift
        /// let resourceType = ResourceProxy(with: resource).resourceType
        /// ```
        public init(id: BaseType.ID, resourceType: String) {
            self.id = id
            self.resourceType = resourceType
        }
    }
    
    
    var resources: [String: ResourceProxy] = [:]
    
    @DataStorageProviders
    var dataStorageProviders: [any DataStorageProvider<FHIR>]
    
    
    public func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) {
        _Concurrency.Task {
            for try await dateSourceElement in asyncSequence {
                switch dateSourceElement {
                case let .addition(resource):
                    guard let id = resource.id?.value?.string else {
                        continue
                    }
                    resources[id] = ResourceProxy(with: resource)
                    for dataStorageProvider in dataStorageProviders {
                        try await dataStorageProvider.process(.addition(resource))
                    }
                case let .removal(removalContext):
                    guard let id = removalContext.id?.value?.string else {
                        continue
                    }
                    resources[id] = nil
                    for dataStorageProvider in dataStorageProviders {
                        try await dataStorageProvider.process(.removal(removalContext))
                    }
                }
            }
        }
    }
}
