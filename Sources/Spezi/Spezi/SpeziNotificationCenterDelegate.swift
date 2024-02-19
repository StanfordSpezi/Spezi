//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UserNotifications


class SpeziNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
#if !os(tvOS)
    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return
        }

        await withTaskGroup(of: Void.self) { group in
            for handler in delegate.spezi.notificationHandler {
                group.addTask {
                    await handler.handleNotificationAction(response)
                }
            }

            for await _ in group {}
        }
    }
#endif

    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return []
        }


        return await withTaskGroup(of: UNNotificationPresentationOptions?.self) { group in
            for handler in delegate.spezi.notificationHandler {
                group.addTask {
                    await handler.receiveIncomingNotification(notification)
                }
            }

            var hasSpecified = false
            let unionOptions: UNNotificationPresentationOptions = await group.reduce(into: []) { result, options in
                guard let options else {
                    return
                }

                hasSpecified = true
                result.formUnion(options)
            }

            if hasSpecified {
                return unionOptions
            } else {
                return [.badge, .badge, .list, .sound]
            }
        }
    }
}


extension SpeziAppDelegate {
    func setupNotificationDelegate() {
        guard !spezi.notificationHandler.isEmpty else {
            return
        }

        let center = UNUserNotificationCenter.current()

        let delegate = SpeziNotificationCenterDelegate()
        Self.notificationDelegate = delegate // maintain reference
        center.delegate = delegate
    }
}
