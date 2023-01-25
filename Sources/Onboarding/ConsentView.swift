//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PencilKit
import SwiftUI
import Views


/// The ``ConsentView`` allows the display of markdown-based documents that can be signed using a family and given name and a hand drawn signature.
///
/// The ``ConsentView`` provides a convenience initalizer with a provided action view using an ``OnboardingActionsView`` (``ConsentView/init(header:asyncMarkdown:footer:action:)``)
/// or a more customized ``ConsentView/init(contentView:actionView:)`` initializer with a custom-provided content and action view.
///
/// ```
/// ConsentView(
///     asyncMarkdown: {
///         Data("This is a *markdown* **example**".utf8)
///     },
///     action: {
///         // The action that should be performed once the user has provided their consent.
///     }
/// )
/// ```
public struct ConsentView<ContentView: View, Action: View>: View {
    private let contentView: ContentView
    private let action: Action
    @State private var name = PersonNameComponents()
    @State private var showSignatureView = false
    @State private var isSigning = false
    @State private var signature = PKDrawing()
    
    
    public var body: some View {
        ScrollViewReader { proxy in
            OnboardingView(
                contentView: {
                    contentView
                },
                actionView: {
                    VStack {
                        Divider()
                        NameFields(name: $name)
                        if showSignatureView {
                            Divider()
                            SignatureView(signature: $signature, isSigning: $isSigning, name: name)
                                .padding(.vertical, 4)
                        }
                        Divider()
                        action
                            .disabled(buttonDisabled)
                            .animation(.easeInOut, value: buttonDisabled)
                            .id("ActionButton")
                            .onChange(of: showSignatureView) { _ in
                                proxy.scrollTo("ActionButton")
                            }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showSignatureView)
                }
            )
                .scrollDisabled(isSigning)
        }
    }
    
    var buttonDisabled: Bool {
        let showSignatureView = !(name.givenName?.isEmpty ?? true) && !(name.familyName?.isEmpty ?? true)
        if !self.showSignatureView && showSignatureView {
            Task { @MainActor in
                self.showSignatureView = showSignatureView
            }
        }
        
        return signature.strokes.isEmpty || (name.givenName?.isEmpty ?? true) || (name.familyName?.isEmpty ?? true)
    }
    
    
    /// Creates a ``ConsentView`` with a provided action view using  an``OnboardingActionsView`` and renders a markdown view.
    /// - Parameters:
    ///   - header: The header view will be displayed above the markdown content.
    ///   - asyncMarkdown: The markdown content provided as an UTF8 encoded `Data` instance that can be provided asynchronously.
    ///   - footer: The footer view will be displayed above the markdown content.
    ///   - action: The action that should be performed once the consent has been given.
    public init(
        @ViewBuilder header: () -> (some View) = { EmptyView() },
        asyncMarkdown: @escaping () async -> Data,
        @ViewBuilder footer: () -> (some View) = { EmptyView() },
        action: @escaping () -> Void
    ) where ContentView == MarkdownView<AnyView, AnyView>, Action == OnboardingActionsView {
        self.init(
            contentView: {
                MarkdownView(
                    asyncMarkdown: asyncMarkdown,
                    header: { AnyView(header()) },
                    footer: { AnyView(footer()) }
                )
            },
            actionView: {
                OnboardingActionsView(String(localized: "CONSENT_ACTION", bundle: .module)) {
                    action()
                }
            }
        )
    }

    /// Creates a ``ConsentView`` with a custom-provided action view.
    /// - Parameters:
    ///   - contentView: The content view providing context about the consent view.
    ///   - actionView: The action view that should be displayed under the name and signature boxes.
    public init(
        @ViewBuilder contentView: () -> (ContentView),
        @ViewBuilder actionView: () -> (Action)
    ) {
        self.contentView = contentView()
        self.action = actionView()
    }
}


struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ConsentView(
                asyncMarkdown: {
                    Data("This is a *markdown* **example**".utf8)
                },
                action: {
                    print("Next step ...")
                }
            )
                .navigationTitle("Consent")
        }
    }
}
