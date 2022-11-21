//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct DateOfBirthPicker: View {
    @Binding var date: Date
    
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1900, month: 1, day: 1)
        let endDate = Date.now
        return calendar.date(from:startDateComponents)!...endDate
    }
    
    var body: some View {
        DatePicker(
            selection: $date,
            in: dateRange,
            displayedComponents: [
                .date
            ]
        ) {
            Text(String(localized: "DATE_OF_BIRTH", bundle: .module))
                .fontWeight(.semibold)
        }
    }
}


struct DateOfBirthPicker_Previews: PreviewProvider {
    @State private static var date: Date = Date.now
    
    
    static var previews: some View {
        Form {
            DateOfBirthPicker(date: $date)
        }
    }
}
