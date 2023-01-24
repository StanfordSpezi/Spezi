//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Combine
import HealthKitDataSource
import SwiftUI


struct HealthKitTestsView: View {
    @EnvironmentObject var healthKitComponent: HealthKit<TestAppStandard>
    @EnvironmentObject var standard: TestAppStandard
    @State var dataChanges: [String] = []
    @State var cancellable: AnyCancellable?
    
    
    var body: some View {
        Button("Ask for authorization") {
            askForAuthorization()
        }
        Button("Trigger data source collection") {
            triggerDataSourceCollection()
        }
        HStack {
            List(dataChanges, id: \.self) { element in
                Text(element)
            }
        }
            .task {
                self.dataChanges = await standard.dataChanges.map { $0.id }
                cancellable = standard.objectWillChange.sink {
                    Task { @MainActor in
                        self.dataChanges = await standard.dataChanges.map { $0.id }
                    }
                }
            }
            .onDisappear {
                cancellable?.cancel()
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
