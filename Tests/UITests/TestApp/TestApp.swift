//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


@main
struct UITestsApp: App {
    enum Tests: String, CaseIterable, Identifiable {
        case localStorage = "LocalStorage"
        case observableObject = "ObservableObject"
        case secureStorage = "SecureStorage"
        
        
        var id: RawValue {
            self.rawValue
        }
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .localStorage:
                LocalStorageTestsView()
            case .observableObject:
                ObservableObjectTestsView()
            case .secureStorage:
                SecureStorageTestsView()
            }
        }
    }
    
    
    @UIApplicationDelegateAdaptor(UITestsAppDelegate.self) var appDelegate
    
    
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
