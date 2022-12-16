//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct MarkdownViewTestView: View {
    @State var viewState: ViewState = .idle
    
    var body: some View {
        MarkdownView(
            asyncMarkdown: {
                try? await Task.sleep(for: .seconds(5))
                return Data("This is a *markdown* **example** taking 5 seconds to load.".utf8)
            },
            state: $viewState,
            header: {
                Text("Header")
            },
            footer: {
                Text("\(String(describing: viewState))")
            }
        )
        MarkdownView(
            markdown: Data("This is a *markdown* **example**.".utf8)
        )
    }
}


struct MarkdownViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownViewTestView()
    }
}
