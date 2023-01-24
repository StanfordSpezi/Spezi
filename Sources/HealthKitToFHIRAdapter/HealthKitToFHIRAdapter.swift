//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR
import HealthKit
import HealthKitDataSource
import HealthKitOnFHIR


public actor HealthKitToFHIRAdapter: SingleValueAdapter {
    public typealias InputElement = HKSample
    public typealias InputRemovalContext = HKSampleRemovalContext
    public typealias OutputElement = FHIR.BaseType
    public typealias OutputRemovalContext = FHIR.RemovalContext
    
    
    public init() {}
    
    
    public func transform(element: InputElement) throws -> OutputElement {
        let resource = try element.resource.get()
        resource.id = element.id.uuidString.asFHIRStringPrimitive()
        return resource
    }
    
    public func transform(removalContext: InputRemovalContext) throws -> OutputRemovalContext {
        OutputRemovalContext(
            id: removalContext.id.uuidString.asFHIRStringPrimitive(),
            resourceType: try removalContext.sampleType.resourceTyoe
        )
    }
}
