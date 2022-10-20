//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``Component`` can conform to ``ObservableObjectComponent`` to inject an ``ObservableObject`` in the SwiftUI view hierachy.
public protocol ObservableObjectComponent: _AnyObservableObjectComponent {
    associatedtype InjectedObject: ObservableObject
    
    
    var observableObject: InjectedObject { get }
}


extension ObservableObjectComponent where Self: ObservableObject {
    public var observableObject: Self {
        self
    }
}


private struct ObservableObjectInjectionViewModifier<O: ObservableObject>: ViewModifier {
    let observableObject: O
    
    
    func body(content: Content) -> some View {
        content.environmentObject(observableObject)
    }
}


extension ObservableObjectComponent {
    public var viewModifier: any ViewModifier {
        ObservableObjectInjectionViewModifier(observableObject: observableObject)
    }
}
