//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


@Observable
class MyModel { // TODO: modifications test
    var message: String

    init(message: String) {
        self.message = message
    }
}


class ComponentWithModifier: Component { // TODO: make it a module at some point?
    @_ModifierPropertyWrapper var modelModifier = MyModifier(model: MyModel(message: "Hello World")) // TODO: rename!
}


struct MyModifier: ViewModifier {
    let model: MyModel

    func body(content: Content) -> some View {
        content
            .environment(model)
    }
}
