//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
@testable import Account


@main
struct UITestsApp: App {
    enum Tests: String, CaseIterable, Identifiable {
        case localStorage = "LocalStorage"
        case observableObject = "ObservableObject"
        case secureStorage = "SecureStorage"
        case healthKit = "HealthKit"
        
        
        var id: RawValue {
            self.rawValue
        }
        
        @MainActor
        @ViewBuilder
        var view: some View {
            switch self {
            case .localStorage:
                LocalStorageTestsView()
            case .observableObject:
                ObservableObjectTestsView()
            case .secureStorage:
                SecureStorageTestsView()
            case .healthKit:
                HealthKitTestsView()
            }
        }
    }
    
    
    @UIApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate
    
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var valid: Bool = false
    
    
    private var validationRules: [ValidationRule] {
        guard let regex = try? Regex("^[a-zA-Z]+$") else {
            return []
        }
        
        return [
            ValidationRule(
                regex: regex,
                message: "Validation failed: Required only letters."
            )
        ]
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SignUp()
                    .environmentObject(Account())
//                List(Tests.allCases) { test in
//                    NavigationLink(test.rawValue, value: test)
//                }
//                    .navigationDestination(for: Tests.self) { test in
//                        test.view
//                    }
//                    .navigationTitle("UITest")
            }
                .cardinalKit(appDelegate)
        }
    }
}
