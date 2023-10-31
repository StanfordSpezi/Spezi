//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import SwiftUI


struct ModelModifier<Model: Observable & AnyObject>: ViewModifier {
    @State private var model: Model

    init(model: Model) {
        self.model = model
    }

    func body(content: Content) -> some View {
        content
            .environment(model)
    }
}
