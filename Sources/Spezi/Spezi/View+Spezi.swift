//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Dispatch
import Foundation
import SwiftUI


struct SpeziViewModifier: ViewModifier {
    var observableObjectProviders: [any ObservableObjectProvider]
    
    
    init(_ anySpezi: AnySpezi) {
        self.observableObjectProviders = anySpezi.observableObjectProviders
    }
    
    
    func body(content: Content) -> some View {
        AnyView(content.inject(observableObjectProviders: observableObjectProviders))
    }
}


extension View {
    /// Use the `spezi()` `View` modifier to configure Spezi for your application.
    /// - Parameter delegate: The `SpeziAppDelegate` used in the SwiftUI `App` instance.
    /// - Returns: A SwiftUI view configured using the Spezi framework
    public func spezi(_ delegate: SpeziAppDelegate) -> some View {
        modifier(SpeziViewModifier(delegate.spezi))
    }
}
