//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct MarkdownView<Header: View, Footer: View>: View {
    let header: Header
    let footer: Footer
    let asyncMarkdown: () async -> Data
    
    @State private var markdown: Data?
    @Binding private var state: ViewState
    
    
    private var markdownString: AttributedString {
        guard let markdown,
              let markdownString = try? AttributedString(
                markdown: markdown,
                options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
              ) else {
            return AttributedString(
                NSLocalizedString(
                    "MARKDOWN_LOADING_ERROR",
                    comment: "Error for not beeing able to parse the privacy policy."
                )
            )
        }
        return markdownString
    }
    
    
    var body: some View {
        ScrollView {
            header
            if markdown == nil {
                ProgressView()
                    .padding()
            } else {
                Text(markdownString)
                    .padding()
            }
            footer
        }
            .task {
                markdown = await asyncMarkdown()
            }
    }
    
    
    init(
        asyncMarkdown: @escaping () async -> Data,
        state: Binding<ViewState> = .constant(.idle),
        header: Header = EmptyView(),
        footer: Footer = EmptyView()
    ) {
        self.header = header
        self.footer = footer
        self.asyncMarkdown = asyncMarkdown
        self._state = state
    }
    
    init(
        markdown: Data,
        state: Binding<ViewState> = .constant(.idle),
        header: Header = EmptyView(),
        footer: Footer = EmptyView()
    ) {
        self.init(
            asyncMarkdown: { markdown },
            state: state,
            header: header,
            footer: footer
        )
    }
}


struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(markdown: Data())
    }
}
