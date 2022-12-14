//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PencilKit
import SwiftUI


/// <#Description#>
public struct CanvasView: UIViewRepresentable {
    /// <#Description#>
    public class Coordinator {
        fileprivate var imageExport: (() -> UIImage)?
        fileprivate var resetFunction: (() -> Void)?
        
        
        /// <#Description#>
        public var image: UIImage {
            imageExport?() ?? UIImage()
        }
        
        
        /// <#Description#>
        public init() {}
        
        
        /// <#Description#>
        public func reset() {
            resetFunction?()
        }
    }
    
    
    let tool: PKInkingTool
    let drawingPolicy: PKCanvasViewDrawingPolicy
    let coordinator: Coordinator
    
    @State private var drawing = PKDrawing()
    @State private var pkcanvasViewSize = CGSize()
    let canvasView = PKCanvasView()
    let picker = PKToolPicker.init()
    
    @Binding private var showToolPicker: Bool
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - tool: <#tool description#>
    ///   - drawingPolicy: <#drawingPolicy description#>
    ///   - coordinator: <#coordinator description#>
    ///   - showToolPicker: <#showToolPicker description#>
    public init(
        tool: PKInkingTool = PKInkingTool(.monoline, color: .label, width: 1),
        drawingPolicy: PKCanvasViewDrawingPolicy = .anyInput,
        coordinator: Coordinator = Coordinator(),
        showToolPicker: Binding<Bool> = .constant(true)
    ) {
        self.tool = tool
        self.drawingPolicy = drawingPolicy
        self._showToolPicker = showToolPicker
        self.coordinator = coordinator
    }
                      
    
    public func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = tool
        self.canvasView.drawingPolicy = drawingPolicy
        
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        self.canvasView.becomeFirstResponder()
        
        return canvasView
    }
    
    public func updateUIView(_ pkcanvasView: PKCanvasView, context: Context) {
        picker.addObserver(canvasView)
        picker.setVisible(showToolPicker, forFirstResponder: pkcanvasView)
        
        pkcanvasViewSize = pkcanvasView.contentSize
        
        Task { @MainActor in
            pkcanvasView.becomeFirstResponder()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        coordinator.imageExport = {
            drawing.image(from: CGRect(origin: .zero, size: pkcanvasViewSize), scale: 5.0)
        }
        coordinator.resetFunction = {
            drawing = PKDrawing()
        }
        return coordinator
    }
}


struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
