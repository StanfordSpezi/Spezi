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


struct ConsentView<Header: View, ContentView: View, Footer: View>: View {
    private let header: Header
    private let contentView: ContentView
    private let footer: Footer
    private let action: () -> Void
    @State private var name = PersonNameComponents()
    @State private var isSigning = false
    @State private var signature = PKDrawing()
    
    
    var body: some View {
        OnboardingView(
            titleView: {
                header
            },
            contentView: {
                contentView
            },
            actionView: {
                VStack {
                    footer
                    Divider()
                    NameFields(name: $name)
                    if showSignatureView {
                        Divider()
                        SignatureView(signature: $signature, isSigning: $isSigning, name: name)
                            .padding(.vertical, 4)
                    }
                    Divider()
                    OnboardingActionsView("CONSENT_ACTION") {
                        
                    }
                        .disabled(buttonDisabled)
                        .animation(.easeInOut, value: buttonDisabled)
                }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showSignatureView)
            }
        )
            .scrollDisabled(isSigning)
    }
    
    var showSignatureView: Bool {
        !(name.givenName?.isEmpty ?? true) && !(name.familyName?.isEmpty ?? true)
    }
    
    var buttonDisabled: Bool {
        signature.strokes.isEmpty || (name.givenName?.isEmpty ?? true) || (name.familyName?.isEmpty ?? true)
    }
    
    
    public init(
        @ViewBuilder titleView: () -> (Header) = { EmptyView() },
        asyncMarkdown: @escaping () async -> Data,
        @ViewBuilder footer: () -> (Footer) = { EmptyView() },
        action: @escaping () -> Void
    ) where ContentView == MarkdownView<EmptyView, EmptyView> {
        self.init(
            header: titleView,
            contentView: {
                MarkdownView(asyncMarkdown: asyncMarkdown)
            },
            footer: footer,
            action: action
        )
    }
    
    public init(
        @ViewBuilder header: () -> (Header) = { EmptyView() },
        @ViewBuilder contentView: () -> (ContentView),
        @ViewBuilder footer: () -> (Footer) = { EmptyView() },
        action: @escaping () -> Void
    ) {
        self.header = header()
        self.contentView = contentView()
        self.footer = footer()
        self.action = action
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
