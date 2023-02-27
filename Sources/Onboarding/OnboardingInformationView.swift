//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


/// The ``OnboardingInformationView`` allows developers to present a unified style the display informational content as defined
/// by the ``OnboardingInformationView/Content`` type.
///
/// The following example displays an ``OnboardingInformationView`` with two information areas:
/// ```swift
/// OnboardingInformationView(
///     areas: [
///         OnboardingInformationView.Content(
///             icon: Image(systemName: "pc"),
///             title: "PC",
///             description: "This is a PC."
///         ),
///         OnboardingInformationView.Content(
///             icon: Image(systemName: "desktopcomputer"),
///             title: "Mac",
///             description: "This is an iMac."
///         )
///     ]
/// )
/// ```
public struct OnboardingInformationView: View {
    /// A ``Content`` defines the way that information is displayed in an ``OnboardingInformationView``.
    public struct Content {
        /// The icon of the area in the ``OnboardingInformationView``.
        public let icon: Image
        /// The title of the area in the ``OnboardingInformationView``.
        public let title: String
        /// The description of the area in the ``OnboardingInformationView``.
        public let description: String
        
        
        /// Creates a new content for an area in the ``OnboardingInformationView``.
        /// - Parameters:
        ///   - icon: The icon of the area in the ``OnboardingInformationView``.
        ///   - title: The title of the area in the ``OnboardingInformationView``.
        ///   - description: The description of the area in the ``OnboardingInformationView``.
        public init<Title: StringProtocol, Description: StringProtocol>(
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
    
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(0..<areas.count, id: \.self) { index in
                areaView(area: areas[index])
            }
        }
    }
    
    
    /// Creates an ``OnboardingInformationView`` instance with a collection of areas defined by the ``Content`` type.
    /// - Parameter areas: The areas that should be displayed.
    public init(areas: [Content]) {
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


#if DEBUG
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
        OnboardingInformationView(
            areas: [
                OnboardingInformationView.Content(
                    icon: Image(systemName: "pc"),
                    title: "PC",
                    description: "This is a PC."
                ),
                OnboardingInformationView.Content(
                    icon: Image(systemName: "desktopcomputer"),
                    title: "Mac",
                    description: "This is an iMac."
                )
            ]
        )
    }
}
#endif
