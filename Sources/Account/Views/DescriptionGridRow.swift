//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct DescriptionGridRow<Description: View, Content: View>: View {
    private let description: Description
    private let content: Content
    
    
    var body: some View {
        GridRow {
            description
                .fontWeight(.semibold)
                .gridColumnAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            content
                .frame(maxWidth: .infinity)
        }
            .contentShape(Rectangle())
    }
    
    
    init(
        @ViewBuilder description: () -> Description,
        @ViewBuilder content: () -> Content
    ) {
        self.description = description()
        self.content = content()
    }
}


struct DescriptionGridRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Form {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    DescriptionGridRow {
                        Text("Description")
                    } content: {
                        Text("Content")
                    }
                    Divider()
                    DescriptionGridRow {
                        Text("Description")
                    } content: {
                        Text("Content")
                    }
                    DescriptionGridRow {
                        Text("Description")
                    } content: {
                        Text("Content")
                    }
                }
            }
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                DescriptionGridRow {
                    Text("Description")
                } content: {
                    Text("Content")
                }
                Divider()
                DescriptionGridRow {
                    Text("Description")
                } content: {
                    Text("Content")
                }
            }
                .padding(32)
        }
            .background(Color(.systemGroupedBackground))
    }
}
