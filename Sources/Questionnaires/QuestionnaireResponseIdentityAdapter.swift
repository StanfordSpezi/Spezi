//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR


actor QuestionnaireResponseIdentityAdapter: SingleValueAdapter {
    typealias InputElement = QuestionnaireResponse
    typealias InputRemovalContext = Resource.ID
    typealias OutputElement = FHIR.BaseType
    typealias OutputRemovalContext = FHIR.RemovalContext
    
    
    func transform(element: InputElement) throws -> OutputElement {
        element
    }
    
    func transform(removalContext: InputRemovalContext) throws -> OutputRemovalContext {
        OutputRemovalContext(
            id: removalContext,
            resourceType: QuestionnaireResponse.resourceType
        )
    }
}
