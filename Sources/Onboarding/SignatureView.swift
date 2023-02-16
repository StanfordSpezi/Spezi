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


/// A ``SignatureView`` enables the collection of signatures using a view that allows freeform signatures using a finger and the Apple Pencil.
///
/// Use SwiftUI `Bindings` to obtain information like the content of the signature and if the user is currently signing:
/// ```swift
/// @State var signature = PKDrawing()
/// @State var isSigning = false
/// 
///
/// SignatureView(
///     signature: $signature,
///     isSigning: $isSigning,
///     name: name
/// )
/// ```
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
    
    
    /// Creates a new instance of an ``SignatureView``.
    /// - Parameters:
    ///   - signature: A `Binding` containing the current signature as an `PKDrawing`.
    ///   - isSigning: A `Binding` indicating if the user is currently signing.
    ///   - name: The name that is deplayed under the signature line.
    ///   - lineOffset: Defines the distance of the signature line from the bottom of the view. The default value is 30.
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


#if DEBUG
struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView()
    }
}
#endif
