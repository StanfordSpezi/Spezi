//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR
import FHIRMockDataStorageProvider
import HealthKitDataSource
import SwiftUI


struct FHIRMockDataStorageProviderTestsView: View {
    @EnvironmentObject var healthKitComponent: HealthKit<FHIR>
    
    
    var body: some View {
        MockUploadList()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Authorize") {
                        _Concurrency.Task {
                            try await healthKitComponent.askForAuthorization()
                        }
                    }
                }
            }
    }
}


#if DEBUG
struct FHIRMockDataStorageProviderTestsView_Previews: PreviewProvider {
    static var previews: some View {
        FHIRMockDataStorageProviderTestsView()
    }
}
#endif
