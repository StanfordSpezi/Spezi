//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import LocalStorage
import SecureStorage
import SwiftUI


struct LocalStorageTestsView: View {
    @EnvironmentObject var localStorage: LocalStorage<TestAppStandard>
    @EnvironmentObject var secureStorage: SecureStorage<TestAppStandard>
    
    
    var body: some View {
        TestAppView(testCase: LocalStorageTests(localStorage: localStorage, secureStorage: secureStorage))
    }
}
