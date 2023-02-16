//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct DataEntryAccountView: View {
    private let content: AnyView
    private let buttonTitle: String
    private let buttonPressed: () async throws -> Void
    private let footer: AnyView
    private let defaultError: String
    
    @Binding private var valid: Bool
    @FocusState private var focusedField: AccountInputFields?
    @State private var state: ViewState = .idle
    
    
    var body: some View {
        ScrollView {
            content
            resetPasswordButton
            footer
        }
            .navigationBarBackButtonHidden(state == .processing)
            .onTapGesture {
                focusedField = nil
            }
            .viewStateAlert(state: $state)
    }
    
    
    private var resetPasswordButton: some View {
        let resetPasswordButtonDisabled = state == .processing || !valid
        
        return Button(action: resetPasswordButtonPressed) {
            Text(buttonTitle)
                .padding(6)
                .frame(maxWidth: .infinity)
                .opacity(state == .processing ? 0.0 : 1.0)
                .overlay {
                    if state == .processing {
                        ProgressView()
                    }
                }
        }
            .buttonStyle(.borderedProminent)
            .disabled(resetPasswordButtonDisabled)
            .padding()
    }
    
    
    init<Content: View, Footer: View>(
        buttonTitle: String,
        defaultError: String,
        focusState: FocusState<AccountInputFields?> = FocusState<AccountInputFields?>(),
        valid: Binding<Bool> = .constant(true),
        buttonPressed: @escaping () async throws -> Void,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.buttonTitle = buttonTitle
        self._focusedField = focusState
        self._valid = valid
        self.buttonPressed = buttonPressed
        self.defaultError = defaultError
        self.content = AnyView(content())
        self.footer = AnyView(footer())
    }
    
    
    private func resetPasswordButtonPressed() {
        guard !(state == .processing) else {
            return
        }
        
        withAnimation(.easeOut(duration: 0.2)) {
            focusedField = .none
            state = .processing
        }
        
        Task {
            do {
                try await buttonPressed()
                withAnimation(.easeIn(duration: 0.2)) {
                    state = .idle
                }
            } catch {
                state = .error(
                    AnyLocalizedError(
                        error: error,
                        defaultErrorDescription: defaultError
                    )
                )
            }
        }
    }
}


#if DEBUG
struct DataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DataEntryAccountView(
                buttonTitle: "Test",
                defaultError: "Error",
                buttonPressed: {
                    try await Task.sleep(for: .seconds(2))
                    print("Pressed!")
                }
            ) {
                Text("Content ...")
            }
                .environmentObject(UsernamePasswordAccountService())
        }
    }
}
#endif
