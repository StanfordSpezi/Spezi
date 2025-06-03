import OSLog
import SpeziFoundation

struct ServiceModuleGroup {
    private enum Input {
        case run(any ServiceModule)
        case cancel(any ServiceModule)
        case clearIdentity(ObjectIdentifier, UUID)
    }

    private let logger: Logger
    private let input: (stream: AsyncStream<Input>, continuation: AsyncStream<Input>.Continuation)

    init(logger: Logger) {
        self.input = AsyncStream.makeStream()
        self.logger = logger
    }

    func run(service: some ServiceModule) {
        input.continuation.yield(.run(service))
    }

    func cancel(service: some ServiceModule) {
        input.continuation.yield(.cancel(service))
    }

    nonisolated func run() async {
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
