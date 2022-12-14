//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct OnboardingInformationView: View {
    struct Content {
        let icon: Image
        let title: String.LocalizationValue
        let description: String.LocalizationValue
        
        
        static var mock: [Content] {
            [
                OnboardingInformationView.Content(icon: Image(systemName: "pc"), title: "PC", description: "This is a PC"),
                OnboardingInformationView.Content(icon: Image(systemName: "desktopcomputer"), title: "Mac", description: "This is an iMac"),
                OnboardingInformationView.Content(icon: Image(systemName: "laptopcomputer"), title: "MacBook", description: "This is a MacBook")
            ]
        }
    }
    
    
    let areas: [Content]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(0..<areas.count, id: \.self) { index in
                areaView(area: areas[index])
            }
        }
    }
    
    func areaView(area: Content) -> some View {
        HStack(spacing: 10) {
            area.icon
                .font(.system(size: 40))
                .frame(width: 40)
                .foregroundColor(.accentColor)
                .padding()
            
            VStack(alignment: .leading) {
                Text(String(localized: area.title))
                    .bold()
                Text(String(localized: area.description))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}


struct AreasView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInformationView(areas: OnboardingInformationView.Content.mock)
    }
}
