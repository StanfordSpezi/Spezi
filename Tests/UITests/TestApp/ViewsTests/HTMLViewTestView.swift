//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views

struct HTMLViewTestView: View {
    @State var viewState: ViewState = .idle

    var body: some View {
        HTMLView(
            asyncHTML: {
                try? await Task.sleep(for: .seconds(5))
                return Data("This is an <strong>HTML example</strong> taking 5 seconds to load.".utf8)
            },
            state: $viewState,
            header: {
                Text("Header")
            },
            footer: {
                Text("\(String(describing: viewState))")
            }
        )
        HTMLView(
            html: Data("This is an <strong>HTML example</strong>.".utf8)
        )
    }
}

struct HTMLViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLViewTestView()
    }
}
