//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Dispatch
import Foundation
import SwiftUI


struct CardinalKitViewModifier: ViewModifier {
    var observableObjectProviders: [any ObservableObjectProvider]
    
    
    init(_ anyCardinalKit: AnyCardinalKit) {
        self.observableObjectProviders = anyCardinalKit.observableObjectProviders
    }
    
    
    func body(content: Content) -> some View {
        AnyView(content.inject(observableObjectProviders: observableObjectProviders))
    }
}


extension View {
    /// Use the `cardinalKit()` `View` modifier to configure CardinalKit for your application.
    /// - Parameter delegate: The `CardinalKitAppDelegate` used in the SwiftUI `App` instance.
    /// - Returns: A SwiftUI view configured using the CardinalKit framework
    public func cardinalKit(_ delegate: CardinalKitAppDelegate) -> some View {
        modifier(CardinalKitViewModifier(delegate.cardinalKit))
    }
}
