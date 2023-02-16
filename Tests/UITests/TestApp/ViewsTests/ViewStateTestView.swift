//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct ViewStateTestView: View {
    struct TestError: LocalizedError {
        let errorDescription: String?
        let failureReason: String?
        let helpAnchor: String?
        let recoverySuggestion: String?
    }
    
    @State var viewState: ViewState = .idle
    
    var body: some View {
        Text("View State: \(String(describing: viewState))")
            .task {
                viewState = .processing
                try? await Task.sleep(for: .seconds(5))
                viewState = .error(
                    AnyLocalizedError(
                        error: TestError(
                            errorDescription: nil,
                            failureReason: "Failure Reason",
                            helpAnchor: "Help Anchor",
                            recoverySuggestion: "Recovery Suggestion"
                        ),
                        defaultErrorDescription: "Error Description"
                    )
                )
            }
            .viewStateAlert(state: $viewState)
    }
}


#if DEBUG
struct ViewStateTestView_Previews: PreviewProvider {
    static var previews: some View {
        ViewStateTestView()
    }
}
#endif
