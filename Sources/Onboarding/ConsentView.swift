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
/// The ``ConsentView`` provides a convenience initializer with a provided action view using an ``OnboardingActionsView`` (``ConsentView/init(header:asyncMarkdown:footer:action:)``)
/// or a more customized ``ConsentView/init(contentView:actionView:)`` initializer with a custom-provided content and action view.
///
/// ```swift
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
    public enum LocalizationDefaults {
        public static var givenName: FieldLocalization {
            FieldLocalization(
                title: String(localized: "NAME_FIELD_GIVEN_NAME_TITLE", bundle: .module),
                placeholder: String(localized: "NAME_FIELD_GIVEN_NAME_PLACEHOLDER", bundle: .module)
            )
        }
        public static var familyName: FieldLocalization {
            FieldLocalization(
                title: String(localized: "NAME_FIELD_FAMILY_NAME_TITLE", bundle: .module),
                placeholder: String(localized: "NAME_FIELD_FAMILY_NAME_PLACEHOLDER", bundle: .module)
            )
        }
    }

    private let contentView: ContentView
    private let action: Action
    private let givenNameField: FieldLocalization
    private let familyNameField: FieldLocalization
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
                        NameFields(
                            name: $name,
                            givenNameField: givenNameField,
                            familyNameField: familyNameField
                        )
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
    ///   - givenNameField: The localization to use for the given (first) name field
    ///   - familyNameField: The localization to use for the family (last) name field
    public init(
        @ViewBuilder header: () -> (some View) = { EmptyView() },
        asyncMarkdown: @escaping () async -> Data,
        @ViewBuilder footer: () -> (some View) = { EmptyView() },
        action: @escaping () -> Void,
        givenNameField: FieldLocalization = LocalizationDefaults.givenName,
        familyNameField: FieldLocalization = LocalizationDefaults.familyName
    ) where ContentView == AnyView, Action == OnboardingActionsView {
        self.init(
            contentView: {
                AnyView(
                    VStack {
                        header()
                        DocumentView(
                            asyncData: asyncMarkdown,
                            type: .markdown
                        )
                        footer()
                    }
                )
            },
            actionView: {
                OnboardingActionsView(String(localized: "CONSENT_ACTION", bundle: .module)) {
                    action()
                }
            },
            givenNameField: givenNameField,
            familyNameField: familyNameField
        )
    }

    /// Creates a ``ConsentView`` with a provided action view using  an``OnboardingActionsView`` and renders HTML in a web view.
    /// - Parameters:
    ///   - header: The header view will be displayed above the html content.
    ///   - asyncHTML: The html content provided as an UTF8 encoded `Data` instance that can be provided asynchronously.
    ///   - footer: The footer view will be displayed above the html content.
    ///   - action: The action that should be performed once the consent has been given.
    public init(
        @ViewBuilder header: () -> (some View) = { EmptyView() },
        asyncHTML: @escaping () async -> Data,
        @ViewBuilder footer: () -> (some View) = { EmptyView() },
        action: @escaping () -> Void,
        givenNameField: FieldLocalization = LocalizationDefaults.givenName,
        familyNameField: FieldLocalization = LocalizationDefaults.familyName
    ) where ContentView == AnyView, Action == OnboardingActionsView {
        self.init(
            contentView: {
                AnyView(
                    VStack {
                        header()
                        DocumentView(
                            asyncData: asyncHTML,
                            type: .html
                        )
                        footer()
                    }
                )
            },
            actionView: {
                OnboardingActionsView(String(localized: "CONSENT_ACTION", bundle: .module)) {
                    action()
                }
            },
            givenNameField: givenNameField,
            familyNameField: familyNameField
        )
    }

    /// Creates a ``ConsentView`` with a custom-provided action view.
    /// - Parameters:
    ///   - contentView: The content view providing context about the consent view.
    ///   - actionView: The action view that should be displayed under the name and signature boxes.
    ///   - givenNameField: The localization to use for the given (first) name field
    ///   - familyNameField: The localization to use for the family (last) name field
    public init(
        @ViewBuilder contentView: () -> (ContentView),
        @ViewBuilder actionView: () -> (Action),
        givenNameField: FieldLocalization = LocalizationDefaults.givenName,
        familyNameField: FieldLocalization = LocalizationDefaults.familyName
    ) {
        self.contentView = contentView()
        self.action = actionView()
        self.givenNameField = givenNameField
        self.familyNameField = familyNameField
    }
}

#if DEBUG
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
#endif
