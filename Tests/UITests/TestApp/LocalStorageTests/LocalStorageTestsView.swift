//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import LocalStorage
import SecureStorage
import SwiftUI


struct LocalStorageTestsView: View {
    @EnvironmentObject var localStorage: LocalStorage<UITestsAppStandard>
    @EnvironmentObject var secureStorage: SecureStorage<UITestsAppStandard>
    @State var testState = "Running ..."
    
    
    var body: some View {
        Text(testState)
            .onAppear {
                let secureStorageTests = LocalStorageTests(localStorage: localStorage, secureStorage: secureStorage)
                
                do {
                    try secureStorageTests.testLocalStorageTestEncrypedManualKeys()
                    // Call test methods multiple times to test retrieval of keys.
                    try secureStorageTests.testLocalStorageTestEncrypedKeychain()
                    try secureStorageTests.testLocalStorageTestEncrypedKeychain()
                    try secureStorageTests.testLocalStorageTestEncrypedSecureEnclave()
                    try secureStorageTests.testLocalStorageTestEncrypedSecureEnclave()
                    testState = "Passed"
                } catch {
                    testState = "Failed: \(error)"
                }
            }
    }
}
