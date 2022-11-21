//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/20/22.
//

import SwiftUI

struct UsernamePasswordLoginServiceButton<Content: View>: View {
    private let content: Content
    
    
    var body: some View {
        HStack {
            content
        }
            .foregroundColor(.accentColor)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.accentColor, lineWidth: 2)
                    .padding(1)
            )
            .cornerRadius(8)
    }
    
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        UsernamePasswordLoginServiceButton() {
            Image(systemName: "ellipsis.rectangle")
                .font(.title2)
            Text("LOGIN_UAP_BUTTON_TITLE", bundle: .module)
        }
    }
}
