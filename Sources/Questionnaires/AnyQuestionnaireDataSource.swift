//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SwiftUI


/// A type erased version of a ``QuestionnaireDataSource``.
public class AnyQuestionnaireDataSource: ObservableObject {
    /// Adds a new `QuestionnaireResponse` to the ``QuestionnaireDataSource``
    /// - Parameter response: The `QuestionnaireResponse` that should be added.
    public func add(_ response: QuestionnaireResponse) { }
    /// Removes a `QuestionnaireResponse` by its response from the ``QuestionnaireDataSource``
    /// - Parameter removalContext:Removes a `QuestionnaireResponse` identified by its identifier.
    public func remove(removalContext: Resource.ID) { }
}
