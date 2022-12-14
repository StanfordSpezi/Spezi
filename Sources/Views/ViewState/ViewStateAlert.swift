//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


private struct ViewStateAlert: ViewModifier {
    @Binding private var state: ViewState
    
    
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
    
    
    init(state: Binding<ViewState>) {
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
    /// <#Description#>
    /// - Parameter state: <#state description#>
    /// - Returns: <#description#>
    public func viewStateAlert(state: Binding<ViewState>) -> some View {
        self
            .modifier(ViewStateAlert(state: state))
    }
}
