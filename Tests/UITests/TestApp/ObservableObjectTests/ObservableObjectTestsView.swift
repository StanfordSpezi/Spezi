//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ObservableObjectTestsView: View {
    typealias ObservableComponent = ObservableComponentTestsComponent<TestAppStandard>
    typealias MultipleObservableComponent = MultipleObservableObjectsTestsComponent<TestAppStandard>
    
    
    @EnvironmentObject var testAppComponent: ObservableComponent
    @EnvironmentObject var multipleObservableInt: MultipleObservableComponent.TestObservableObject<Int>
    @EnvironmentObject var multipleObservableString: MultipleObservableComponent.TestObservableObject<String>
    
    
    var body: some View {
        TestAppView(
            testCase: ObservableObjectTests(
                testAppComponent: testAppComponent,
                multipleObservableInt: multipleObservableInt,
                multipleObservableString: multipleObservableString
            )
        )
    }
}
