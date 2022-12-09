//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


public struct UserProfileView: View {
    private let name: PersonNameComponents
    private let imageLoader: () async -> Image?
    
    @State private var image: Image?
    
    
    public var body: some View {
        GeometryReader { context in
            ZStack {
                if let image {
                    Circle()
                        .foregroundColor(Color(.systemBackground))
                    image.resizable()
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundColor(Color(.systemGray3))
                    Text(name.formatted(.name(style: .abbreviated)))
                        .foregroundColor(.init(UIColor.systemBackground))
                        .font(
                            .system(
                                size: min(context.size.height, context.size.width) * 0.45,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                }
            }.frame(
                width: min(context.size.height, context.size.width),
                height: min(context.size.height, context.size.width)
            )
        }
            .aspectRatio(1, contentMode: .fit)
            .contentShape(Circle())
            .task {
                self.image = await imageLoader()
            }
    }
    
    
    public init(name: PersonNameComponents, imageLoader: @escaping () async -> Image? = { nil }) {
        self.name = name
        self.imageLoader = imageLoader
    }
}


struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            UserProfileView(
                name: PersonNameComponents(givenName: "Paul", familyName: "Schmiedmayer")
            )
                .frame(width: 100, height: 50)
                .padding()
            UserProfileView(
                name: PersonNameComponents(
                    namePrefix: "Prof.",
                    givenName: "Oliver",
                    middleName: "Oppers",
                    familyName: "Aalami"
                )
            )
                .frame(width: 100, height: 100)
                .padding()
                .background(Color(.systemBackground))
                .colorScheme(.dark)
            UserProfileView(
                name: PersonNameComponents(givenName: "Vishnu", familyName: "Ravi"),
                imageLoader: {
                    try? await Task.sleep(for: .seconds(2))
                    return Image(systemName: "person.crop.artframe")
                }
            )
                .frame(width: 50, height: 100)
                .shadow(radius: 4)
                .padding()
        }
    }
}
