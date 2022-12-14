//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct WidthPreferenceKey: PreferenceKey, Equatable {
    static var defaultValue: CGFloat = 0
    
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}


struct HorizontalGeometryReader<Content: View>: View {
    private var content: (CGFloat) -> Content
    @State private var width: CGFloat = 0
    
    
    var body: some View {
        content(width)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                }
            )
            .onPreferenceChange(WidthPreferenceKey.self) { width in
                self.width = width
            }
    }
    
    
    init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.content = content
    }
}
