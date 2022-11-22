//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/22/22.
//

import SwiftUI


struct OnTapFocus<FocusedField: Hashable>: ViewModifier {
    private let fieldIdentifier: FocusedField
    
    @FocusState private var focusedState: FocusedField?
    
    
    func body(content: Content) -> some View {
        content
            .focused($focusedState, equals: fieldIdentifier)
            .onTapGesture {
                focusedState = fieldIdentifier
            }
    }
    
    
    init(
        focusedState: FocusState<FocusedField?>,
        fieldIdentifier: FocusedField
    ) {
        self._focusedState = focusedState
        self.fieldIdentifier = fieldIdentifier
    }
    
    init() where FocusedField == UUID {
        self.init(
            focusedState: FocusState<FocusedField?>(),
            fieldIdentifier: UUID()
        )
    }
}


extension View {
    func onTapFocus() -> some View {
        modifier(OnTapFocus())
    }
    
    func onTapFocus<FocusedField: Hashable>(
        focusedField: FocusState<FocusedField?>,
        fieldIdentifier: FocusedField
    ) -> some View {
        modifier(OnTapFocus(focusedState: focusedField, fieldIdentifier: fieldIdentifier))
    }
}
