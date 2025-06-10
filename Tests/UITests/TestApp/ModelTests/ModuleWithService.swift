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
@MainActor
final class ModuleWithService: ServiceModule, EnvironmentAccessible {
    enum State: String, CustomStringConvertible {
        case uninitialized
        case configured
        case loaded
        case finished

        var description: String {
            switch self {
            case .uninitialized:
                "Module is not running."
            case .configured:
                "Module is configured."
            case .loaded:
                "Module is running."
            case .finished:
                "Module completed!"
            }
        }
    }

    var state: State = .uninitialized

    nonisolated init() {}

    func configure() {
        state = .configured
    }

    func run() async {
        let input = AsyncStream<Void>.makeStream()

        if state == .configured {
            state = .loaded
        }

        for await _ in input.stream {}

        state = .finished
    }
}
