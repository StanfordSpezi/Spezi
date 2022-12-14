//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// <#Description#>
public struct WidthPreferenceKey: PreferenceKey, Equatable {
    public static var defaultValue: CGFloat = 0
    
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}


/// <#Description#>
public struct HorizontalGeometryReader<Content: View>: View {
    private var content: (CGFloat) -> Content
    @State private var width: CGFloat = 0
    
    
    public var body: some View {
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
    
    
    /// <#Description#>
    /// - Parameter content: <#content description#>
    public init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.content = content
    }
}
