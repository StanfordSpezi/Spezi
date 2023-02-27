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
        DocumentView(
            asyncData: {
                try? await Task.sleep(for: .seconds(5))
                return Data("This is an HTML example taking 5 seconds to load.".utf8)
            },
            type: .html
        )
        HTMLView(
            html: Data("This is an HTML example.".utf8)
        )
    }
}

struct HTMLViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLViewTestView()
    }
}
