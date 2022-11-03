//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


private struct ObservableObjectInjectionViewModifier<O: ObservableObject>: ViewModifier {
    let observableObject: O
    
    
    func body(content: Content) -> some View {
        content.environmentObject(observableObject)
    }
}


/// A ``Component`` can conform to ``ObservableObjectComponent`` to inject an ``ObservableObject`` in the SwiftUI view hierachy.
public protocol ObservableObjectComponent {
    /// The ``ObservableObjectComponent/InjectedObject`` defines the type that will be injected into the SwiftUI environment.
    associatedtype InjectedObject: ObservableObject
    
    
    /// The ``ObservableObject`` instance that should be injected in the SwiftUI environment.
    var observableObject: InjectedObject { get }
}


extension ObservableObjectComponent where Self: ObservableObject {
    // A documentation for this methodd exists in the `ObservableObjectComponent` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var observableObject: Self {
        self
    }
}


extension ObservableObjectComponent {
    var viewModifier: some ViewModifier {
        ObservableObjectInjectionViewModifier(observableObject: observableObject)
    }
}
