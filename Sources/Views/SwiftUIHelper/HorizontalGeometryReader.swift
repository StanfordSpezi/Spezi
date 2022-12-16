//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// The ``WidthPreferenceKey`` enables outer views to get access to the current width calculated by the ``HorizontalGeometryReader``
/// using the SwiftUI preference mechanisms.
public struct WidthPreferenceKey: PreferenceKey, Equatable {
    public static var defaultValue: CGFloat = 0
    
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}


/// An ``HorizontalGeometryReader`` enables a closure parameter-based and preference-based mechanism to read out the width of a specific view.
/// Refer to ``WidthPreferenceKey`` for using the SwiftUI preference mechanism-based system or the ``HorizontalGeometryReader/init(content:)`` initializer
/// for the closure-based approach.
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
    
    
    /// Creates a new instance of the ``HorizontalGeometryReader``.
    /// - Parameter content: The content closure that gets the calculated width as a parameter.
    public init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.content = content
    }
}
