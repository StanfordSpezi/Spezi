//
// This source file is part of the Stanford XCTestExtensions open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziFoundation

final class ServiceModuleGroup: Sendable {
    private enum Input {
        case run(any ServiceModule)
        case cancel(any ServiceModule)
        case clearIdentity(ObjectIdentifier, UUID)
    }

    private enum State: Sendable {
        case idle
        case running
    }

    private let logger: Logger
    private let input: (stream: AsyncStream<Input>, continuation: AsyncStream<Input>.Continuation)

    nonisolated(unsafe) private var state: State
    private let lock = NSLock()

    init(logger: Logger) {
        self.input = AsyncStream.makeStream()
        self.logger = logger
        self.state = .idle
    }

    func run(service: some ServiceModule) {
        input.continuation.yield(.run(service))
    }

    func cancel(service: some ServiceModule) {
        input.continuation.yield(.cancel(service))
    }

    nonisolated func run() async {
        let run = lock.withLock {
            switch state {
            case .idle:
                self.state = .running
                return true
            case .running:
                return false
            }
        }

        guard run else {
            logger.warning("Spezi service group is already running. Make sure to only use the `spezi` view modifier once in your view hierarchy.")
            return
        }

        logger.debug("Starting the Spezi Service.")

        defer {
            logger.debug("Shutting down Spezi.")

            lock.withLock {
                state = .idle
            }
        }

        let input = input

        await withDiscardingTaskGroup { group in
            // all the running tasks
            var taskHandles: [ObjectIdentifier: (handle: CancelableTaskHandle, id: UUID)] = [:]

            for await event in input.stream {
                switch event {
                case let .run(module):
                    guard taskHandles[module.moduleId] == nil else {
                        logger.warning("Tried to run module \(type(of: module)) twice. Ignoring second request.")
                        continue
                    }

                    let id = UUID()

                    let handle = group.addCancelableTask {
                        await module.run()

                        // clear in a way that doesn't race and doesn't extend the lifetime of the module.
                        input.continuation.yield(.clearIdentity(module.moduleId, id))
                    }

                    taskHandles[module.moduleId] = (handle, id)
                case let .cancel(module):
                    let entry = taskHandles.removeValue(forKey: module.moduleId)
                    entry?.handle.cancel()
                case let .clearIdentity(key, id):
                    guard let handle = taskHandles[key],
                          handle.id == id else {
                        continue
                    }
                    taskHandles.removeValue(forKey: key)
                    handle.handle.cancel()
                }
            }
        }
    }
}
