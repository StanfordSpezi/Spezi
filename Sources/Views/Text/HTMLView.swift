//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import WebKit

/// An``HTMLView`` allows the display of HTML in a web view including the addition of a header and footer view.
///
/// ```
/// @State var viewState: ViewState = .idle
///
/// HTMLView(
///     asyncHTML: {
///         // Load your HTML from a remote source or disk storage ...
///         try? await Task.sleep(for: .seconds(5))
///         return Data("This is an <strong>HTML example</strong> taking 5 seconds to load.".utf8)
///     },
///     state: $viewState,
///     header: {
///         Text("Header")
///     },
///     footer: {
///         Text("Footer")
///     }
/// )
/// ```
private struct WebView: UIViewRepresentable {
    var htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}


public struct HTMLView<Header: View, Footer: View>: View {
    private let header: Header
    private let footer: Footer
    private let asyncHTML: () async -> Data

    @State private var html: Data?
    @Binding private var state: ViewState


    private var htmlString: String {
        guard let html else {
            let errorString = String(localized: "HTML_LOADING_ERROR", bundle: .module)
            return """
                    <meta name=\"viewport\" content=\"initial-scale=1.0\" />
                    <p style=\"text-align: center\">\(errorString)</p>
                    """
        }

        return String(decoding: html, as: UTF8.self)
    }

    public var body: some View {
        VStack {
            header
            if html == nil {
                ProgressView()
                    .padding()
            } else {
                WebView(htmlContent: htmlString)
            }
            footer
        }
        .task {
            html = await asyncHTML()
        }
    }

    /// Creates an ``HTMLView`` that displays HTML that is loaded asynchronously.
    /// - Parameters:
    ///   - asyncHTML: The async closure to load the html as a utf8 representation.
    ///   - state: A `Binding` to observe the ``ViewState`` of the ``HTMLView``.
    ///   - header: An optional header of the ``HTMLView``
    ///   - footer: An optional footer of the ``HTMLView``
    public init(
        asyncHTML: @escaping () async -> Data,
        state: Binding<ViewState> = .constant(.idle),
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder footer: () -> (Footer) = { EmptyView() }
    ) {
        self.header = header()
        self.footer = footer()
        self.asyncHTML = asyncHTML
        self._state = state
    }

    /// Creates an ``HTMLView`` that displays the HTML content.
    /// - Parameters:
    ///   - html: A `Data` instance containing the html as an utf8 representation.
    ///   - state: A `Binding` to observe the ``ViewState`` of the ``HTMLView``.
    ///   - header: An optional header of the ``HTMLView``
    ///   - footer: An optional footer of the ``HTMLView``
    public init(
        html: Data,
        state: Binding<ViewState> = .constant(.idle),
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder footer: () -> (Footer) = { EmptyView() }
    ) {
        self.init(
            asyncHTML: { html },
            state: state,
            header: header,
            footer: footer
        )
    }
}
