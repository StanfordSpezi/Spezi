//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import ModelsR4
import SwiftUI


/// A type erased version of a ``QuestionnaireDataSource``.
final class AnyQuestionnaireDataSource: ObservableObject {
    private let _add: (QuestionnaireResponse) -> Void
    private let _remove: (Resource.ID) -> Void
    
    
    init<Q: QuestionnaireDataSource<S>, S: Standard>(_ questionnaireDataSource: Q) {
        self._add = questionnaireDataSource.add
        self._remove = questionnaireDataSource.remove
    }
    
    
    /// Adds a new `QuestionnaireResponse` to the ``QuestionnaireDataSource``
    /// - Parameter response: The `QuestionnaireResponse` that should be added.
    func add(_ response: QuestionnaireResponse) {
        _add(response)
    }
    /// Removes a `QuestionnaireResponse` by its response from the ``QuestionnaireDataSource``
    /// - Parameter removalContext:Removes a `QuestionnaireResponse` identified by its identifier.
    func remove(removalContext: Resource.ID) {
        _remove(removalContext)
    }
}
