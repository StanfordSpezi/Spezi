//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

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
///     type: .markdown,
///     header: {
///         Text("Header")
///     },
///     footer: {
///         Text("Footer")
///     }
/// )
/// ```


public enum DocumentType {
    case markdown
    case html
}

public struct DocumentView<Header: View, Footer: View>: View {
    private let type: DocumentType
    private let asyncData: () async -> Data
    private let header: Header
    private let footer: Footer

    public var documentView: AnyView {
        switch(self.type) {
        case .markdown:
            return AnyView(MarkdownView(asyncMarkdown: asyncData))
        case .html:
            return AnyView(HTMLView(asyncHTML: asyncData))
        }
    }

    public var body: some View {
        VStack {
            header
            documentView
            footer
        }
    }

    
    /// Creates a ``DocumentView`` that displays the content of a markdown or HTML file as an utf8 representation that is loaded asynchronously.
    /// - Parameters:
    ///   - asyncData: The async closure to load the markdown or html file as an utf8 representation.
    public init(
        asyncData: @escaping () async -> Data,
        type: DocumentType,
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder footer: () -> (Footer) = { EmptyView() }
    ) {
        self.asyncData = asyncData
        self.type = type
        self.header = header()
        self.footer = footer()
    }

    /// Creates a ``DocumentView`` that displays the content of a markdown or HTML file as an utf8 representation that is loaded asynchronously.
    /// - Parameters:
    ///   - data: the html or markdown data as a utf8 representation
    public init(
        data: Data,
        type: DocumentType,
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder footer: () -> (Footer) = { EmptyView() }
    ){
        self.init(
            asyncData: { data },
            type: type,
            header: header,
            footer: footer
        )
    }
}
