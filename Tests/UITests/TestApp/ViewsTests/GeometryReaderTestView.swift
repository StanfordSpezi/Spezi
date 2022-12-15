//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct GeometryReaderTestView: View {
    @State var name = PersonNameComponents()
    
    var body: some View {
        VStack {
            HorizontalGeometryReader { wight in
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .border(.red)
                    Text("\(wight)")
                }
            }
                .frame(width: 200)
                .border(.blue)
            HorizontalGeometryReader { wight in
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .border(.red)
                    Text("\(wight)")
                }
            }
                .frame(width: 300)
                .border(.blue)
        }
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct GeometryReaderTestView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderTestView()
    }
}
