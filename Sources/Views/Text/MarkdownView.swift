//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct MarkdownView<Header: View, Footer: View>: View {
    private let header: Header
    private let footer: Footer
    private let asyncMarkdown: () async -> Data
    
    @State private var markdown: Data?
    @Binding private var state: ViewState
    
    
    private var markdownString: AttributedString {
        guard let markdown,
              let markdownString = try? AttributedString(
                markdown: markdown,
                options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
              ) else {
            return AttributedString(
                String(localized: "MARKDOWN_LOADING_ERROR", bundle: .module)
            )
        }
        return markdownString
    }
    
    
    public var body: some View {
        VStack {
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
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - asyncMarkdown: <#asyncMarkdown description#>
    ///   - state: <#state description#>
    ///   - header: <#header description#>
    ///   - footer: <#footer description#>
    public init(
        asyncMarkdown: @escaping () async -> Data,
        state: Binding<ViewState> = .constant(.idle),
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder footer: () -> (Footer) = { EmptyView() }
    ) {
        self.header = header()
        self.footer = footer()
        self.asyncMarkdown = asyncMarkdown
        self._state = state
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - markdown: <#markdown description#>
    ///   - state: <#state description#>
    ///   - header: <#header description#>
    ///   - footer: <#footer description#>
    public init(
        markdown: Data,
        state: Binding<ViewState> = .constant(.idle),
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder footer: () -> (Footer) = { EmptyView() }
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
