//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@testable import Onboarding
import SwiftUI


struct ViewsTestsView: View {
    enum ViewsTestElements: String, CaseIterable, Codable {
        case canvas = "Canvas"
        case nameFields = "Name Fields"
        case userProfile = "User Profile"
        case geometryReader = "Geometry Reader"
        case label = "Label"
        case markdownView = "Markdown View"
        case viewState = "View State"
    }
    
    
    @Binding private var path: NavigationPath
    
    
    var body: some View {
        List(ViewsTestElements.allCases, id: \.rawValue) { viewsTestElement in
            NavigationLink(viewsTestElement.rawValue, value: viewsTestElement)
        }
            .navigationTitle("Views Tests")
            .navigationDestination(for: ViewsTestElements.self) { viewsTestElement in
                switch viewsTestElement {
                case .canvas:
                    canvas
                case .nameFields:
                    nameFields
                case .userProfile:
                    userProfile
                case .geometryReader:
                    geometryReader
                case .label:
                    label
                case .markdownView:
                    markdownView
                case .viewState:
                    viewState
                }
            }
    }
    
    
    private var canvas: some View {
        Text("Canvas")
    }
    
    private var nameFields: some View {
        Text("Name Fields")
    }
    
    private var userProfile: some View {
        Text("User Profile")
    }
    
    private var geometryReader: some View {
        Text("Geometry Reader")
    }
    
    private var label: some View {
        Text("Label")
    }
    
    private var markdownView: some View {
        Text("Markdown View")
    }
    
    private var viewState: some View {
        Text("View State")
    }
    
    
    init(navigationPath: Binding<NavigationPath>) {
        self._path = navigationPath
    }
}


struct ViewsTestsView_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    
    
    static var previews: some View {
        NavigationStack {
            OnboardingTestsView(navigationPath: $path)
        }
    }
}
