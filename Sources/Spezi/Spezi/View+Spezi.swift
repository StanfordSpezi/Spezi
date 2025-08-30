//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
public import SwiftUI


@_spi(APISupport)
public struct SpeziViewModifier: ViewModifier {
    @State private var spezi: Spezi
    
    
    public init(_ spezi: Spezi) {
        self.spezi = spezi
    }
    
    
    public func body(content: Content) -> some View {
        spezi.viewModifiers
            .modify(content)
            .task(spezi.run) // service lifecycle
    }
}


extension View {
    /// Configure Spezi for your application using a delegate.
    /// - Parameter delegate: The ``SpeziAppDelegate`` used in the SwiftUI App instance.
    /// - Returns: The configured view using the Spezi framework.
    @MainActor
    public func spezi(_ delegate: SpeziAppDelegate) -> some View {
        modifier(SpeziViewModifier(delegate.spezi))
    }
}


extension Array where Element == any ViewModifier {
    @MainActor
    fileprivate func modify<V: View>(_ view: V) -> AnyView {
        var view = AnyView(view)
        for modifier in self {
            view = modifier.modify(view)
        }
        return view
    }
}


extension ViewModifier {
    fileprivate func modify(_ view: AnyView) -> AnyView {
        AnyView(view.modifier(self))
    }
}
