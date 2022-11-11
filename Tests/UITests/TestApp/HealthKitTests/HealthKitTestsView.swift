//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import HealthKitDataSource


struct HealthKitTestsView: View {
    @EnvironmentObject var healthKitComponent: HealthKit<TestAppStandard>
    
    
    var body: some View {
        Button("Ask for authorization") {
            askForAuthorization()
        }
        Button("Trigger data source collection") {
            triggerDataSourceCollection()
        }
    }
    
    private func askForAuthorization() {
        Task {
            try await healthKitComponent.askForAuthorization()
        }
    }
    
    private func triggerDataSourceCollection() {
        Task {
            await healthKitComponent.triggerDataSourceCollection()
        }
    }
}
