//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) @testable import Spezi
import Testing


@MainActor
@Suite("Storage Concurrency")
struct StorageConcurrencyTests {
    private final class LoadedModule: Module {}

    private final class ExternallyOwnedModule: Module {}

    /// Reads storage and purges stale weak references from background threads while the main actor loads and unloads modules.
    ///
    /// `retrieveDependencyReplacement(for:)` is reached from `@Dependency` accesses on arbitrary threads and writes to storage.
    /// Run with `--sanitize=thread` to detect unsynchronized access.
    @Test("Concurrent storage reads and writes off the main actor")
    func concurrentAccess() async {
        let spezi = Spezi(standard: DefaultStandard(), modules: [])
        let iterations = 500

        let backgroundTasks = (0..<4).map { _ in
            Task.detached {
                for _ in 0..<iterations {
                    _ = spezi._modules.count
                    _ = spezi.retrieveDependencyReplacement(for: ExternallyOwnedModule.self)
                }
            }
        }

        for _ in 0..<iterations {
            let module = LoadedModule()
            spezi.loadModule(module)
            do {
                // weakly referenced and immediately deallocated, leaving a stale reference for the background tasks to purge
                let external = ExternallyOwnedModule()
                spezi.loadModule(external, ownership: .external)
            }
            spezi.unloadModule(module)
            await Task.yield()
        }

        for task in backgroundTasks {
            await task.value
        }

        #expect(spezi.module(LoadedModule.self) == nil)
    }
}
