//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Represents the type of document to be displayed.
public enum DocumentType {
    /// A document written in markdown.
    case markdown
    /// A document written in HTML.
    case html
}

/// A ``DocumentView`` allows the display of a markdown or HTML document.
///
/// ```
/// @State var viewState: ViewState = .idle
///
/// DocumentView(
///     asyncData: {
///         // Load your document from a remote source or disk storage ...
///         try? await Task.sleep(for: .seconds(5))
///         return Data("This is a *markdown* **example** taking 5 seconds to load.".utf8)
///     },
///     type: .markdown
/// )
/// ```
public struct DocumentView: View {
    private let type: DocumentType
    private let asyncData: () async -> Data

    @Binding private var state: ViewState

    public var documentView: AnyView {
        switch self.type {
        case .markdown:
            return AnyView(MarkdownView(asyncMarkdown: asyncData))
        case .html:
            return AnyView(HTMLView(asyncHTML: asyncData))
        }
    }

    public var body: some View {
        documentView
    }


    /// Creates a ``DocumentView`` that displays the content of a markdown or HTML file as an utf8 representation that is loaded asynchronously.
    /// - Parameters:
    ///   - asyncData: The async closure to load the markdown or html file as an utf8 representation.
    ///   - type: the type of document (i.e. markdown or html) represented by ``DocumentType``.
    ///   - state: A `Binding` to observe the ``ViewState`` of the ``DocumentView``
    public init(
        asyncData: @escaping () async -> Data,
        type: DocumentType,
        state: Binding<ViewState> = .constant(.idle)
    ) {
        self.asyncData = asyncData
        self.type = type
        self._state = state
    }

    /// Creates a ``DocumentView`` that displays the content of a markdown or HTML file as an utf8 representation that is loaded asynchronously.
    /// - Parameters:
    ///   - data: the html or markdown data as a utf8 representation.
    ///   - type: the type of document (i.e. markdown or html) represented by ``DocumentType``.
    ///   - state: A `Binding` to observe the ``ViewState`` of the ``DocumentView``
    public init(
        data: Data,
        type: DocumentType,
        state: Binding<ViewState> = .constant(.idle)
    ) {
        self.init(
            asyncData: { data },
            type: type,
            state: state
        )
    }
}
