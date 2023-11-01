//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


struct CustomKey: EnvironmentKey {
    static var defaultValue = false
}

@Observable
class MyModel2 {
    var message: String

    init(message: String) {
        self.message = message
    }
}


private struct MyModifier: ViewModifier {
    @Environment(MyModel2.self)
    var model

    func body(content: Content) -> some View {
        content
            .environment(\.customKey, model.message == "Hello World")
    }
}


class ModuleWithModel: Module {
    @Model var model = MyModel2(message: "Hello World")
    @Modifier fileprivate var modifier = MyModifier() // ensure reordering happens, ViewModifier must be able to access the model from environment
}


extension EnvironmentValues {
    var customKey: Bool {
        get {
            self[CustomKey.self]
        }
        set {
            self[CustomKey.self] = newValue
        }
    }
}
