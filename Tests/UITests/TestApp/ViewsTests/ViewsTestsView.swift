//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct ViewsTestsView: View {
    enum ViewsTestElements: String, CaseIterable, Codable {
        case canvas = "Canvas"
        case nameFields = "Name Fields"
        case userProfile = "User Profile"
        case geometryReader = "Geometry Reader"
        case label = "Label"
        case lazyText = "Lazy Text"
        case markdownView = "Markdown View"
        case htmlView = "HTML View"
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
                case .lazyText:
                    lazyText
                case .markdownView:
                    markdownView
                case .htmlView:
                    htmlView
                case .viewState:
                    viewState
                }
            }
    }
    
    
    @ViewBuilder
    private var canvas: some View {
        CanvasTestView()
    }
    
    @ViewBuilder
    private var nameFields: some View {
        NameFieldsTestView()
    }
    
    @ViewBuilder
    private var userProfile: some View {
        UserProfileView(
            name: PersonNameComponents(givenName: "Paul", familyName: "Schmiedmayer")
        )
            .frame(width: 100)
        UserProfileView(
            name: PersonNameComponents(givenName: "Leland", familyName: "Stanford"),
            imageLoader: {
                try? await Task.sleep(for: .seconds(1))
                return Image(systemName: "person.crop.artframe")
            }
        )
            .frame(width: 200)
    }
    
    @ViewBuilder
    private var geometryReader: some View {
        GeometryReaderTestView()
    }
    
    @ViewBuilder
    private var label: some View {
        Label(
            """
            This is a label ...
            An other text. This is longer and we can check if the justified text works as epxected. This is a very long text.
            """,
            textAllignment: .justified,
            textColor: .blue
        )
            .border(.gray)
        Label(
            """
            This is a label ...
            An other text. This is longer and we can check if the justified text works as epxected. This is a very long text.
            """,
            textAllignment: .right,
            textColor: .red
        )
            .border(.red)
    }
    
    @ViewBuilder
    private var markdownView: some View {
        MarkdownViewTestView()
    }

    @ViewBuilder
    private var htmlView: some View {
        HTMLViewTestView()
    }
    
    @ViewBuilder
    private var lazyText: some View {
        ScrollView {
            LazyText(
                text: """
                This is a long text ...
                
                And some more lines ...
                
                And a third line ...
                """
            )
        }
    }
    
    @ViewBuilder
    private var viewState: some View {
        ViewStateTestView()
    }
    
    
    init(navigationPath: Binding<NavigationPath>) {
        self._path = navigationPath
    }
}


#if DEBUG
struct ViewsTestsView_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    
    
    static var previews: some View {
        NavigationStack {
            ViewsTestsView(navigationPath: $path)
        }
    }
}
#endif
