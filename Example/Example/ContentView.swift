//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


struct ContentView: View {
    @EnvironmentObject var exampleAppComponent: ExampleAppComponent<ExampleAppStandard>
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(exampleAppComponent.greeting)
                .frame(height: 40)
        }
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ExampleAppComponent<ExampleAppStandard>(greeting: "Hello, Paul!"))
    }
}
