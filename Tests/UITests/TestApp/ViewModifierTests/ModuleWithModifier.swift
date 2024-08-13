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


struct MyModifier: ViewModifier {
    @Observable
    class ModifierState {
        @MainActor var appeared: Bool = false

        init() {}
    }

    // We expect that a EnvironmentAccessible dependency is available inside the environment of a modifier
    // that is placed in the parent module.
    @Environment(ModuleB.self) private var module: ModuleB?

    let model: MyModel

    @State private var state = ModifierState()

    @MainActor private var alertBinding: Binding<Bool> {
        Binding {
            module == nil && state.appeared
        } set: { _ in
        }
    }

    func body(content: Content) -> some View {
        content
            .environment(model)
            .environment(state)
            .alert("Test Failed", isPresented: alertBinding) {
            } message: {
                Text(verbatim: "ModuleB dependency was not available in the environment of the modifier of the parent!")
            }
    }
}

private class ModuleA: Module, DefaultInitializable {
    required init() {}
}

private class ModuleB: Module, EnvironmentAccessible {
    @Dependency(ModuleA.self) private var module

    init() {}
}


class ModuleWithModifier: Module {
    @Dependency(ModuleB.self) private var moduleB = ModuleB()

    @Modifier fileprivate var modelModifier: MyModifier

    @MainActor
    init() {
        modelModifier = MyModifier(model: MyModel(message: "Hello World"))
    }
}
