//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct SignatureView: View {
    private let coordinator = CanvasView.Coordinator()
    private let name: PersonNameComponents
    private let lineOffset: CGFloat
    
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.secondarySystemBackground)
            Rectangle()
                .fill(.secondary)
                .frame(width: .infinity, height: 1, alignment: .center)
                .padding(.horizontal, 20)
                .padding(.bottom, lineOffset)
            Text("X")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .padding(.bottom, lineOffset + 2)
            Text(name.formatted(.name(style: .long)))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .padding(.bottom, lineOffset - 18)
            CanvasView(showToolPicker: .constant(false))
        }
            .frame(height: 120)
            .shadow(color: Color(.tertiarySystemBackground), radius: 5)
            .padding()
    }
    
    var signatureImage: UIImage {
        coordinator.image
    }
    
    
    init(name: PersonNameComponents = PersonNameComponents(), lineOffset: CGFloat = 30) {
        self.name = name
        self.lineOffset = lineOffset
    }
    
    
    func reset() {
        coordinator.reset()
    }
}


struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView()
    }
}
