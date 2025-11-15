//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A description of a `Module`.
struct ModuleDescription {
    let name: String

    var loggerCategory: String {
        name
    }

    init<M: Module>(from module: M) {
        self.name = "\(M.self)"
    }
}


extension Module {
    var moduleDescription: ModuleDescription {
        ModuleDescription(from: self)
    }
}
