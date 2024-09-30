//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import OSLog
import SpeziFoundation
import SwiftUI


@MainActor
@_spi(APISupport)
public final class RemoteNotificationRegistrationSupport: KnowledgeSource, Sendable {
    public typealias Anchor = SpeziAnchor

    private let logger = Logger(subsystem: "edu.stanford.spezi", category: "RemoteNotificationRegistrationSupport")

    fileprivate(set) var continuation: CheckedContinuation<Data, Error>?
    fileprivate(set) var access = AsyncSemaphore()


    nonisolated init() {}


    func handleDeviceTokenUpdate(_ deviceToken: Data) {
        // might also be called if, e.g., app is restored from backup and is automatically registered for remote notifications.
        // This can be handled through the `NotificationHandler` protocol.

        resume(with: .success(deviceToken))
    }

    func handleFailedRegistration(_ error: Error) {
        let resumed = resume(with: .failure(error))

        if !resumed {
            logger.warning("Received a call to \(#function) while we were not waiting for a notifications registration request.")
        }
    }


    @discardableResult
    private func resume(with result: Result<Data, Error>) -> Bool {
        if let continuation {
            self.continuation = nil
            access.signal()
            continuation.resume(with: result)
            return true
        }
        return false
    }

    public func callAsFunction() async throws -> Data {
        try await access.waitCheckingCancellation()

#if targetEnvironment(simulator)
        async let _ = withTimeout(of: .seconds(5)) { @MainActor in
            logger.warning("Registering for remote notifications seems to be not possible on this simulator device. Timing out ...")
            self.continuation?.resume(with: .failure(TimeoutError()))
        }
#endif

        return try await withCheckedThrowingContinuation { continuation in
            assert(self.continuation == nil, "continuation wasn't nil")
            self.continuation = continuation
            _Application.shared.registerForRemoteNotifications()
        }
    }
}


extension Spezi {
    /// Provides support to call the `registerForRemoteNotifications()` method on the application.
    ///
    /// This helper type makes sure to bridge access to the delegate methods that will be called when executing `registerForRemoteNotifications()`.
    @MainActor
    @_spi(APISupport)
    public var remoteNotificationRegistrationSupport: RemoteNotificationRegistrationSupport {
        let support: RemoteNotificationRegistrationSupport
        if let existing = spezi.storage[RemoteNotificationRegistrationSupport.self] {
            support = existing
        } else {
            support = RemoteNotificationRegistrationSupport()
            spezi.storage[RemoteNotificationRegistrationSupport.self] = support
        }
        return support
    }
}
