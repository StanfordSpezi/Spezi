//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct CardinalKitViewModifier: ViewModifier {
    fileprivate init(_ anyCardinalKit: AnyCardinalKit) {
        
    }
    
    
    func body(content: Content) -> some View {
        #warning("TODO: Do we want to inject some content here?")
        return content
    }
}

extension ObservableObject {
    func register<V: View>(to view: V) -> some View {
        view.environmentObject(self)
    }
}


extension View {
    /// Use the `cardinalKit()` `View` modifier to configure CardinalKit for your application.
    /// - Parameter delegate: The `CardinalKitAppDelegate` used in the SwiftUI `App` instance.
    /// - Returns: A SwiftUI view configured using the CardinalKit framework
    public func cardinalKit(_ delegate: CardinalKitAppDelegate) -> some View {
        let test: ModifiedContent<Self, CardinalKitViewModifier> = modifier(CardinalKitViewModifier(delegate.cardinalKit))
        #warning("TODO: Figure out a way to apply different observable objects to the modified view!")
        return test
    }
}
