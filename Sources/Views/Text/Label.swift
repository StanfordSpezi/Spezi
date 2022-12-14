//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


private struct _Label: UIViewRepresentable {
    let text: String
    let textStyle: UIFont.TextStyle
    let textAllignment: NSTextAlignment
    let textColor: UIColor
    let numberOfLines: Int
    let preferredMaxLayoutWidth: CGFloat
    
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = textAllignment
        label.numberOfLines = numberOfLines
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        updateUIView(label, context: context)
        
        return label
    }
    
    func updateUIView(_ label: UILabel, context: Context) {
        label.text = text
        label.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }
}


/// <#Description#>
public struct Label: View {
    private let text: String
    private let textStyle: UIFont.TextStyle
    private let textAllignment: NSTextAlignment
    private let textColor: UIColor
    private let numberOfLines: Int
    
    
    public var body: some View {
        HorizontalGeometryReader { width in
            _Label(
                text: text,
                textStyle: textStyle,
                textAllignment: textAllignment,
                textColor: textColor,
                numberOfLines: numberOfLines,
                preferredMaxLayoutWidth: width
            )
        }
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - textStyle: <#textStyle description#>
    ///   - textAllignment: <#textAllignment description#>
    ///   - textColor: <#textColor description#>
    ///   - numberOfLines: <#numberOfLines description#>
    public init(
        _ text: String,
        textStyle: UIFont.TextStyle = .body,
        textAllignment: NSTextAlignment = .justified,
        textColor: UIColor = .label,
        numberOfLines: Int = 0
    ) {
        self.text = text
        self.textStyle = textStyle
        self.textAllignment = textAllignment
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
