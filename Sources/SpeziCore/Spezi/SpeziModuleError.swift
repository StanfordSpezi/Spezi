//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


enum SpeziModuleError: Error, CustomStringConvertible {
    case dependency(DependencyManagerError)
    case property(SpeziPropertyError)

    case moduleStillRequired(module: String, dependents: [String])

    var description: String {
        switch self {
        case let .dependency(error):
            error.description
        case let .property(error):
            error.description
        case let .moduleStillRequired(module, dependents):
            "Tried to unload Module \(type(of: module)) that is still required by peer Module(s): \(dependents.joined(separator: ", "))"
        }
    }
}
