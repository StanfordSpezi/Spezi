//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PencilKit
import SwiftUI
import Views


public struct SignatureView: View {
    @Environment(\.undoManager) private var undoManager
    @Binding private var signature: PKDrawing
    @Binding private var isSigning: Bool
    @State private var canUndo = false
    private let name: PersonNameComponents
    private let lineOffset: CGFloat
    
    
    public var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                Color(.secondarySystemBackground)
                Rectangle()
                    .fill(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: 1)
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
                CanvasView(drawing: $signature, isDrawing: $isSigning, showToolPicker: .constant(false))
            }
                .frame(height: 120)
            Button(String(localized: "SIGNATURE_VIEW_UNDO", bundle: .module)) {
                undoManager?.undo()
                canUndo = undoManager?.canUndo ?? false
            }
                .disabled(!canUndo)
        }
            .onChange(of: isSigning) { _ in
                Task { @MainActor in
                    canUndo = undoManager?.canUndo ?? false
                }
            }
            .transition(.opacity)
            .animation(.easeInOut, value: canUndo)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - signature: <#signature description#>
    ///   - isSigning: <#isSigning description#>
    ///   - name: <#name description#>
    ///   - lineOffset: <#lineOffset description#>
    init(
        signature: Binding<PKDrawing> = .constant(PKDrawing()),
        isSigning: Binding<Bool> = .constant(false),
        name: PersonNameComponents = PersonNameComponents(),
        lineOffset: CGFloat = 30
    ) {
        self._signature = signature
        self._isSigning = isSigning
        self.name = name
        self.lineOffset = lineOffset
    }
}


struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView()
    }
}
