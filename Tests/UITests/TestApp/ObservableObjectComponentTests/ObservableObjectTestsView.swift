//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


struct ObservableObjectTestsView: View {
    @EnvironmentObject var testAppComponent: ObservableComponentTestsComponent<UITestsAppStandard>
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(testAppComponent.greeting)
                .frame(height: 40)
        }
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ObservableObjectTestsView()
            .environmentObject(ObservableComponentTestsComponent<UITestsAppStandard>(greeting: "Hello, Paul!"))
    }
}
