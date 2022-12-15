//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PencilKit
import SwiftUI


private struct _CanvasView: UIViewRepresentable {
    class Coordinator: NSObject, ObservableObject, PKCanvasViewDelegate {
        let canvasView: _CanvasView
        
        
        init(canvasView: _CanvasView) {
            self.canvasView = canvasView
        }
        
        
        func canvasViewDidBeginUsingTool(_ pkCanvasView: PKCanvasView) {
            Task { @MainActor in
                canvasView.isDrawing = true
            }
        }
        
        func canvasViewDidEndUsingTool(_ pkCanvasView: PKCanvasView) {
            Task { @MainActor in
                canvasView.isDrawing = false
            }
        }
        
        func canvasViewDrawingDidChange(_ pkCanvasView: PKCanvasView) {
            Task { @MainActor in
                canvasView.drawing = pkCanvasView.drawing
            }
        }
    }
    
    let tool: PKInkingTool
    let drawingPolicy: PKCanvasViewDrawingPolicy
    let picker = PKToolPicker()
    
    @Binding private var drawing: PKDrawing
    @Binding private var isDrawing: Bool
    @Binding private var showToolPicker: Bool
    
    
    init(
        drawing: Binding<PKDrawing> = .constant(PKDrawing()),
        isDrawing: Binding<Bool> = .constant(false),
        tool: PKInkingTool = PKInkingTool(.pencil, color: .label, width: 1),
        drawingPolicy: PKCanvasViewDrawingPolicy = .anyInput,
        showToolPicker: Binding<Bool> = .constant(true)
    ) {
        self._drawing = drawing
        self._isDrawing = isDrawing
        self.tool = tool
        self.drawingPolicy = drawingPolicy
        self._showToolPicker = showToolPicker
    }
                      
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.tool = tool
        canvasView.drawingPolicy = drawingPolicy
        canvasView.delegate = context.coordinator
        canvasView.drawing = drawing
        
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        picker.addObserver(canvasView)
        picker.setVisible(showToolPicker, forFirstResponder: canvasView)
        
        if showToolPicker {
            Task { @MainActor in
                canvasView.becomeFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: self)
    }
}


/// <#Description#>
public struct CanvasView: View {
    /// <#Description#>
    public struct CanvasSizePreferenceKey: PreferenceKey, Equatable {
        public static var defaultValue: CGSize = .zero
        
        
        public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
    
    
    let tool: PKInkingTool
    let drawingPolicy: PKCanvasViewDrawingPolicy
    @Binding private var drawing: PKDrawing
    @Binding private var isDrawing: Bool
    @Binding private var showToolPicker: Bool
    
    
    public var body: some View {
        GeometryReader { proxy in
            _CanvasView(
                drawing: $drawing,
                isDrawing: $isDrawing,
                tool: tool,
                drawingPolicy: drawingPolicy,
                showToolPicker: $showToolPicker
            )
                .preference(key: CanvasSizePreferenceKey.self, value: proxy.size)
        }
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - drawing: <#drawing description#>
    ///   - isDrawing: <#isDrawing description#>
    ///   - tool: <#tool description#>
    ///   - drawingPolicy: <#drawingPolicy description#>
    ///   - showToolPicker: <#showToolPicker description#>
    public init(
        drawing: Binding<PKDrawing> = .constant(PKDrawing()),
        isDrawing: Binding<Bool> = .constant(false),
        tool: PKInkingTool = PKInkingTool(.pencil, color: .label, width: 1),
        drawingPolicy: PKCanvasViewDrawingPolicy = .anyInput,
        showToolPicker: Binding<Bool> = .constant(true)
    ) {
        self._drawing = drawing
        self._isDrawing = isDrawing
        self.tool = tool
        self.drawingPolicy = drawingPolicy
        self._showToolPicker = showToolPicker
    }
}


struct SignatureView_Previews: PreviewProvider {
    @State private static var isDrawing = false
    
    
    static var previews: some View {
        VStack {
            Text("\(isDrawing.description)")
            CanvasView(isDrawing: $isDrawing)
        }
    }
}
