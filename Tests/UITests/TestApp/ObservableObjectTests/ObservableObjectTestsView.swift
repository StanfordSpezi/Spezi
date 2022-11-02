//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ObservableObjectTestsView: View {
    @EnvironmentObject var testAppComponent: ObservableComponentTestsComponent<TestAppStandard>
    
    
    var body: some View {
        TestAppView(testCase: ObservableObjectTests(testAppComponent: testAppComponent))
    }
}
