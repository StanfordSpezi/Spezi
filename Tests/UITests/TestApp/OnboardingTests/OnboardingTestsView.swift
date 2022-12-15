//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@testable import Onboarding
import SwiftUI


struct OnboardingTestsView: View {
    @State private var isDrawing: Bool = false
    
    
    var body: some View {
        List {
            NavigationLink("Signature View ") {
//                VStack {
//                    Text("\(isDrawing.description)")
//                    CanvasView(isDrawing: $isDrawing)
//                }
                ConsentView(
                    titleView: {
                        OnboardingTitleView(title: "Consent", subtitle: "Version 1.0")
                    },
                    asyncMarkdown: {
                        Data("This is a *markdown* **example**".utf8)
                    },
                    action: {
                        print("Next step ...")
                    }
                )
            }
        }
    }
}


struct OnboardingTestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OnboardingTestsView()
        }
    }
}
