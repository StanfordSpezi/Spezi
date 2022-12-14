//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


@main
struct UITestsApp: App {
    enum Tests: String, CaseIterable, Identifiable {
        case account = "Account"
        case contacts = "Contacts"
        case healthKit = "HealthKit"
        case localStorage = "LocalStorage"
        case observableObject = "ObservableObject"
        case secureStorage = "SecureStorage"
        
        
        var id: RawValue {
            self.rawValue
        }
        
        @MainActor
        @ViewBuilder
        var view: some View {
            switch self {
            case .account:
                AccountTestsView()
            case .contacts:
                ContactsTestsView()
            case .healthKit:
                HealthKitTestsView()
            case .localStorage:
                LocalStorageTestsView()
            case .observableObject:
                ObservableObjectTestsView()
            case .secureStorage:
                SecureStorageTestsView()
            }
        }
    }
    
    
    @UIApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List(Tests.allCases) { test in
                    NavigationLink(test.rawValue, value: test)
                }
                    .navigationDestination(for: Tests.self) { test in
                        test.view
                    }
                    .navigationTitle("UITest")
            }
                .cardinalKit(appDelegate)
        }
    }
}
