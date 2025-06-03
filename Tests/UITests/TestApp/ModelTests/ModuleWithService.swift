//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


struct ModuleWithServiceView: View {
    @Environment(ModuleWithService.self)
    private var module

    var body: some View {
        Text(module.state.description)
    }
}


@Observable
final class ModuleWithService: ServiceModule, EnvironmentAccessible {
    enum State: CustomStringConvertible {
        case uninitialized
        case loaded
        case finished

        var description: String {
            switch self {
            case .uninitialized:
                "Module is not running."
            case .loaded:
                "Module is running."
            case .finished:
                "Module completed!"
            }
        }
    }

    @MainActor var state: State = .uninitialized

    nonisolated init() {}

    @MainActor
    func run() async {
        let input = AsyncStream<Void>.makeStream()

        if state == .uninitialized {
            state = .loaded
        }

        for await _ in input.stream {}

        state = .finished
    }
}
