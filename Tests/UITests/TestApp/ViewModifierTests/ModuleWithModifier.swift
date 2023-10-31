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
class MyModel {
    var message: String

    init(message: String) {
        self.message = message
    }
}


private struct MyModifier: ViewModifier {
    let model: MyModel

    func body(content: Content) -> some View {
        content
            .environment(model)
    }
}


class ModuleWithModifier: Module {
    @Modifier fileprivate var modelModifier = MyModifier(model: MyModel(message: "Hello World"))
}
