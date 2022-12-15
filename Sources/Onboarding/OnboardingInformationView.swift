//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct OnboardingInformationView: View {
    struct Content {
        let icon: Image
        let title: String
        let description: String
        
        
        init<Title: StringProtocol, Description: StringProtocol>(
            icon: Image,
            title: Title,
            description: Description
        ) {
            self.icon = icon
            self.title = title.localized
            self.description = description.localized
        }
    }
    
    
    private let areas: [Content]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(0..<areas.count, id: \.self) { index in
                areaView(area: areas[index])
            }
        }
    }
    
    
    init(areas: [Content]) {
        self.areas = areas
    }
    
    
    private func areaView(area: Content) -> some View {
        HStack(spacing: 10) {
            area.icon
                .font(.system(size: 40))
                .frame(width: 40)
                .foregroundColor(.accentColor)
                .padding()
            
            VStack(alignment: .leading) {
                Text(area.title)
                    .bold()
                Text(area.description)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}


struct AreasView_Previews: PreviewProvider {
    static var mock: [OnboardingInformationView.Content] {
        [
            OnboardingInformationView.Content(
                icon: Image(systemName: "pc"),
                title: "PC",
                description: "This is a PC. And we can write a lot about PCs in a section like this. A very long text!"
            ),
            OnboardingInformationView.Content(
                icon: Image(systemName: "desktopcomputer"),
                title: "Mac",
                description: "This is an iMac"
            ),
            OnboardingInformationView.Content(
                icon: Image(systemName: "laptopcomputer"),
                title: "MacBook",
                description: "This is a MacBook"
            )
        ]
    }
    
    
    static var previews: some View {
        OnboardingInformationView(areas: mock)
    }
}
