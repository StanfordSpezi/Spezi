//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AccountViewStateAlert: ViewModifier {
    @Binding private var state: AccountViewState
    
    
    private var errorAlertBinding: Binding<Bool> {
        Binding {
            if case .error = state {
                return true
            } else {
                return false
            }
        } set: { newValue in
            if newValue == false {
                state = .idle
            }
        }
    }
    
    
    fileprivate init(state: Binding<AccountViewState>) {
        self._state = state
    }
    
    
    func body(content: Content) -> some View {
        content
            .alert(state.errorTitle, isPresented: errorAlertBinding) {
                Text(state.errorDescription)
            }
    }
}


extension View {
    func viewStateAlert(state: Binding<AccountViewState>) -> some View {
        self
            .modifier(AccountViewStateAlert(state: state))
    }
}
