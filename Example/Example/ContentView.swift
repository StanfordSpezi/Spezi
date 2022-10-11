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
    let cardinalKit = CardinalKit()
    @MainActor @State var greeting: String?
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Group {
                if let greeting = greeting {
                    Text(greeting)
                } else {
                    ProgressView()
                }
            }
                .frame(height: 40)
        }
            .padding()
            .onAppear {
                Task {
                    greeting = try await cardinalKit.greet("Paul")
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
