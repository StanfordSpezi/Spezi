//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UserNotifications


class SpeziNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
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

    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        guard let delegate = SpeziAppDelegate.appDelegate else {
            return []
        }


        return await withTaskGroup(of: UNNotificationPresentationOptions.self) { group in
            for handler in delegate.spezi.notificationHandler {
                group.addTask {
                    await handler.receiveIncomingNotification(notification)
                }
            }
            
            // TODO: fine to just merge all options? (this doesn't work with the empty default implementation!)
            return await group.reduce(into: []) { result, options in
                result.formUnion(options)
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
