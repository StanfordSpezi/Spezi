//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``MarkdownView`` allows the display of a markdown file including the addition of a header and footer view.
///
/// ```swift
/// @State var viewState: ViewState = .idle
///
/// MarkdownView(
///     asyncMarkdown: {
///         // Load your markdown file from a remote source or disk storage ...
///         try? await Task.sleep(for: .seconds(5))
///         return Data("This is a *markdown* **example** taking 5 seconds to load.".utf8)
///     },
///     state: $viewState
/// )
/// ```
public struct MarkdownView: View {
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
            if markdown == nil {
                ProgressView()
                    .padding()
            } else {
                Text(markdownString)
                    .padding()
            }
        }
            .task {
                markdown = await asyncMarkdown()
            }
    }
    
    
    /// Creates a ``MarkdownView`` that displayes the content of a markdown file as an utf8 representation that is loaded asynchronously.
    /// - Parameters:
    ///   - asyncMarkdown: The async closure to load the markdown as an utf8 representation.
    ///   - state: A `Binding` to observe the ``ViewState`` of the ``MarkdownView``.
    public init(
        asyncMarkdown: @escaping () async -> Data,
        state: Binding<ViewState> = .constant(.idle)
    ) {
        self.asyncMarkdown = asyncMarkdown
        self._state = state
    }
    
    /// Creates a ``MarkdownView`` that displayes the content of a markdown file
    /// - Parameters:
    ///   - asyncMarkdown: A `Data` instance containing the markdown file as an utf8 representation.
    ///   - state: A `Binding` to observe the ``ViewState`` of the ``MarkdownView``.
    public init(
        markdown: Data,
        state: Binding<ViewState> = .constant(.idle)
    ) {
        self.init(
            asyncMarkdown: { markdown },
            state: state
        )
    }
}


#if DEBUG
struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(markdown: Data())
    }
}
#endif
