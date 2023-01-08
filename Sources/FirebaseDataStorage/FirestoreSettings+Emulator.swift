//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore

extension FirestoreSettings: @unchecked Sendable {
    /// <#Description#>
    public static var emulator: FirestoreSettings {
        let settings = FirestoreSettings()
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        return settings
    }
}
