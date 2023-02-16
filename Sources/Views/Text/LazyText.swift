//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A lazy loading text view that is especially useful for larger text files that should not be displayed all at once.
///
/// Uses a `LazyVStack` under the hood to load and display the text line-by-line.
public struct LazyText: View {
    private let text: String
    @State private var lines: [(linenumber: Int, text: String)] = []
    
    
    public var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(lines, id: \.linenumber) { line in
                Text(line.text)
                    .multilineTextAlignment(.leading)
            }
        }
            .onAppear {
                var lineNumber = 0
                text.enumerateLines { line, _ in
                    lines.append((lineNumber, line))
                    lineNumber += 1
                }
            }
    }
    
    
    /// A lazy loading text view that is especially useful for larger text files that should not be displayed all at once.
    /// - Parameter text: The text that should be displayed in the ``LazyText`` view.
    public init(text: String) {
        self.text = text
    }
}


#if DEBUG
struct LazyText_Previews: PreviewProvider {
    static var previews: some View {
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
}
#endif
