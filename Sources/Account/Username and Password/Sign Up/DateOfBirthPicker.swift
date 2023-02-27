//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct DateOfBirthPicker: View {
    @Binding private var date: Date
    @EnvironmentObject private var localizationEnvironmentObject: UsernamePasswordAccountService
    private let localization: ConfigurableLocalization<String>
    
    
    private var dateOfBirthTitle: String {
        switch localization {
        case .environment:
            return localizationEnvironmentObject.localization.signUp.dateOfBirthTitle
        case let .value(dateOfBirthTitle):
            return dateOfBirthTitle
        }
    }
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1900, month: 1, day: 1)
        let endDate = Date.now
        
        guard let startDate = calendar.date(from: startDateComponents) else {
            fatalError("Could not translate \(startDateComponents) to a valid date.")
        }
        
        return startDate...endDate
    }
    
    var body: some View {
        DatePicker(
            selection: $date,
            in: dateRange,
            displayedComponents: [
                .date
            ]
        ) {
            Text(dateOfBirthTitle)
                .fontWeight(.semibold)
        }
    }
    
    
    init(date: Binding<Date>, title: String) {
        self._date = date
        self.localization = .value(title)
    }
    
    
    init(date: Binding<Date>) {
        self._date = date
        self.localization = .environment
    }
}


#if DEBUG
struct DateOfBirthPicker_Previews: PreviewProvider {
    @State private static var date = Date.now
    
    
    static var previews: some View {
        VStack {
            Form {
                DateOfBirthPicker(date: $date)
            }
                .frame(height: 200)
            DateOfBirthPicker(date: $date)
                .padding(32)
        }
            .environmentObject(UsernamePasswordAccountService())
            .background(Color(.systemGroupedBackground))
    }
}
#endif
