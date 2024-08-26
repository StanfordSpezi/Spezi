//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct RemoteNotificationsTestView: View {
    @Environment(NotificationModule.self)
    private var notificationModule

    @State private var token: Data?
    @State private var error: Error?

    @State private var task: Task<Void, Never>?

    var body: some View {
        List { // swiftlint:disable:this closure_body_length
            Section("Token") {
                HStack {
                    Text(verbatim: "Token")
                    Spacer()
                    if let token {
                        Text(token.description)
                            .foregroundStyle(.green)
                    } else if let error = error as? LocalizedError,
                              let description = error.errorDescription ?? error.failureReason {
                        Text(verbatim: description)
                            .foregroundStyle(.red)
                    } else if error != nil {
                        Text(verbatim: "failed")
                            .foregroundStyle(.red)
                    } else {
                        Text(verbatim: "none")
                            .foregroundStyle(.secondary)
                    }
                }
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("token-field")
            }

            Section("Actions") {
                Button("Register") {
                    task = Task { @MainActor in
                        do {
                            token = try await notificationModule.registerRemoteNotifications()
                        } catch {
                            self.error = error
                        }
                    }
                }
                Button("Unregister") {
                    notificationModule.unregisterRemoteNotifications()
                    token = nil
                    error = nil
                }
            }
        }
            .onDisappear {
                task?.cancel()
            }
    }
}


#if DEBUG
#Preview {
    RemoteNotificationsTestView()
        .environment(NotificationModule())
}
#endif
