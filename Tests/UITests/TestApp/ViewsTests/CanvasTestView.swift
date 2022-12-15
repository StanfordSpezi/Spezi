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


struct CanvasTestView: View {
    @State var isDrawing = false
    @State var didDrawAnything = false
    @State var showToolPicker = false
    @State var drawing = PKDrawing()
    
    
    var body: some View {
        VStack {
            Text("Did Draw Anything: \(didDrawAnything.description)")
            Button("Show Tool Picker") {
                showToolPicker.toggle()
            }
            CanvasView(
                drawing: $drawing,
                isDrawing: $isDrawing,
                tool: .init(.pencil, color: .red, width: 10),
                drawingPolicy: .anyInput,
                showToolPicker: $showToolPicker
            )
        }
            .onChange(of: isDrawing) { newValue in
                if newValue {
                    didDrawAnything = true
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct CanvasTestView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasTestView()
    }
}
