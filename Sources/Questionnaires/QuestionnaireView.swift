//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ModelsR4
import ResearchKit
import SwiftUI


/// Renders a FHIR `Questionnaire`.
public struct QuestionnaireView: View {
    @EnvironmentObject private var questionnaireDataSource: AnyQuestionnaireDataSource
    private let questionnaire: Questionnaire
    private let questionnaireResponseClosure: ((QuestionnaireResponse) -> Void)?
    private let completionStepMessage: String?
    
    
    public var body: some View {
        if let task = createTask(questionnaire: questionnaire) {
            ORKOrderedTaskView(
                tasks: task,
                delegate: ORKTaskFHIRDelegate(questionnaireResponse),
                tintColor: .accentColor
            )
                .ignoresSafeArea(.container, edges: .bottom)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        } else {
            Text("QUESTIONNAIRE_LOADING_ERROR_MESSAGE")
        }
    }
    
    
    /// - Parameters:
    ///   - questionnaire: The FHIR `Questionnaire` that should be displayed.
    ///   - completionStepMessage: Optional completion message that can be appended at the end of the questionnaire.
    ///   - questionnaireResponse: Optional response closure that can be used to manually obtain the `QuestionnaireResponse`.
    ///                            If no closure is provided, the `QuestionnaireResponse` instance is send to the `QuestionnaireDataSource` found in the SwiftUI environment.
    public init(
        questionnaire: Questionnaire,
        completionStepMessage: String? = nil,
        questionnaireResponse: ((QuestionnaireResponse) -> Void)? = nil
    ) {
        self.questionnaire = questionnaire
        self.completionStepMessage = completionStepMessage
        self.questionnaireResponseClosure = questionnaireResponse
    }
    
    
    /// Creates a ResearchKit navigable task from a FHIR questionnaire
    /// - Parameter questionnaire: a FHIR questionnaire
    /// - Returns: a ResearchKit navigable task
    private func createTask(questionnaire: Questionnaire) -> ORKNavigableOrderedTask? {
        // Create a completion step to add to the end of the Questionnaire (optional)
        var completionStep: ORKCompletionStep?
        if let completionStepMessage {
            completionStep = ORKCompletionStep(identifier: "completion-step")
            completionStep?.text = completionStepMessage
        }
        
        // Create a navigable task from the Questionnaire
        do {
            return try ORKNavigableOrderedTask(questionnaire: questionnaire, completionStep: completionStep)
        } catch {
            print("Error creating task: \(error)")
            return nil
        }
    }
    
    private func questionnaireResponse(_ questionnaireResponse: QuestionnaireResponse) {
        if let questionnaireResponseClosure {
            questionnaireResponseClosure(questionnaireResponse)
        }
        questionnaireDataSource.add(questionnaireResponse)
    }
}


struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView(questionnaire: Questionnaire.dateTimeExample)
    }
}
