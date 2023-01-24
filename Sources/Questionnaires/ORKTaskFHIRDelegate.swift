//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4
import ResearchKit
import ResearchKitOnFHIR


class ORKTaskFHIRDelegate: NSObject, ORKTaskViewControllerDelegate, ObservableObject {
    private var questionnaireResponse: (QuestionnaireResponse) -> Void
    
    
    init(_ questionnaireResponse: @escaping (QuestionnaireResponse) -> Void) {
        self.questionnaireResponse = questionnaireResponse
    }
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
        case .completed:
            let fhirResponse = taskViewController.result.fhirResponse
            fhirResponse.subject = Reference(reference: FHIRPrimitive(FHIRString("My Patient")))
            
            questionnaireResponse(fhirResponse)
        default:
            break
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
