//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct SecureStorageTestsView: View {
    @State var testState = "Running ..."
    
    
    var body: some View {
        Text(testState)
            .onAppear {
                let secureStorageTests = SecureStorageTests()
                
                do {
                    try secureStorageTests.testInternetCredentials()
                } catch {
                    testState = "Failed: \(error)"
                }
                
                testState = "Passed"
            }
    }
}
