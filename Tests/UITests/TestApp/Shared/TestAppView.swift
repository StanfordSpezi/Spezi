//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct TestAppView: View {
    @State var testState = "Running ..."
    let testCase: any TestAppTestCase
    
    
    var body: some View {
        Text(testState)
            .task {
                do {
                    try await testCase.runTests()
                    testState = "Passed"
                } catch {
                    testState = "Failed: \(error)"
                }
            }
    }
    
    
    init(testCase: any TestAppTestCase) {
        self.testCase = testCase
    }
}
