import SpeziFoundation

struct ServiceModuleGroup {
    private enum Input {
        case run(any ServiceModule) // TODO: support unloading?
        case cancel(any ServiceModule)
    }

    private let input: (stream: AsyncStream<Input>, continuation: AsyncStream<Input>.Continuation)

    init() {
        self.input = AsyncStream.makeStream()
    }

    func run(service: some ServiceModule) {
        input.continuation.yield(.run(service))
    }

    func cancel(service: some ServiceModule) {
        input.continuation.yield(.cancel(service)) // TODO: allow to await the cancellation somehow?
    }

    nonisolated func run() async {
        let stream = input.stream
        await withDiscardingTaskGroup { group in
            var taskHandles: [ObjectIdentifier: CancelableTaskHandle] = [:]

            // TODO: keep track of tasks with cancellable child tasks?
            for await input in stream {
                switch input {
                case let .run(module):
                    guard taskHandles[module.moduleId] == nil else {
                        continue // TODO: log that, how to handle? just replace it?
                    }

                    let handle = group.addCancelableTask {
                        // TODO: make the task cancellable, some of the dependency un-injection must be moved to when the module finished unloading?
                        await module.run()
                    }

                    taskHandles[module.moduleId] = handle
                case let .cancel(module):
                    let handle = taskHandles.removeValue(forKey: module.moduleId)
                    handle?.cancel()
                }
            }
        }
    }
}
