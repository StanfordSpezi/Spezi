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
public protocol ObservableObjectComponent: _AnyObservableObjectComponent {
    associatedtype InjectedObject: ObservableObject
    
    
    /// The ``ObservableObject`` instance that should be injected in the SwiftUI environment.
    var observableObject: InjectedObject { get }
}


extension ObservableObjectComponent where Self: ObservableObject {
    // swiftlint:disable:next missing_docs
    public var observableObject: Self {
        self
    }
}


extension ObservableObjectComponent {
    // swiftlint:disable:next missing_docs
    public var viewModifier: any ViewModifier {
        ObservableObjectInjectionViewModifier(observableObject: observableObject)
    }
}
