//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// <#Description#>
public struct Schedule: Codable, Sendable {
    /// <#Description#>
    public enum ScheduleEnd: Codable, Sendable {
        /// <#Description#>
        case numberOfEvents(Int)
        /// <#Description#>
        case endDate(Date)
        /// <#Description#>
        case numberOfEventsOrEndDate(Int, Date)
        
        
        var endDate: Date? {
            switch self {
            case let .endDate(endDate), let .numberOfEventsOrEndDate(_, endDate):
                return endDate
            case .numberOfEvents:
                return nil
            }
        }
        
        var numberOfEvents: Int? {
            switch self {
            case let .numberOfEvents(numberOfEvents), let .numberOfEventsOrEndDate(numberOfEvents, _):
                return numberOfEvents
            case .endDate:
                return nil
            }
        }
        
        
        static func minimum(_ lhs: Self, _ rhs: Self) -> ScheduleEnd {
            switch (lhs.numberOfEvents, lhs.endDate, rhs.numberOfEvents, rhs.endDate) {
            case let (.some(numberOfEvents), .none, .none, .some(date)),
                 let (.none, .some(date), .some(numberOfEvents), .none):
                return .numberOfEventsOrEndDate(numberOfEvents, date)
            case let (nil, .some(lhsDate), nil, .some(rhsDate)):
                return .endDate(min(lhsDate, rhsDate))
            case let (.some(lhsNumberOfEvents), nil, .some(rhsNumberOfEvents), nil):
                return .numberOfEvents(min(lhsNumberOfEvents, rhsNumberOfEvents))
            case let (.some(lhsNumberOfEvents), nil, .some(rhsNumberOfEvents), .some(date)),
                 let (.some(lhsNumberOfEvents), .some(date), .some(rhsNumberOfEvents), nil):
                return .numberOfEventsOrEndDate(min(lhsNumberOfEvents, rhsNumberOfEvents), date)
            case let (.some(numberOfEvents), .some(lhsDate), nil, .some(rhsDate)),
                 let (nil, .some(lhsDate), .some(numberOfEvents), .some(rhsDate)):
                return .numberOfEventsOrEndDate(numberOfEvents, min(lhsDate, rhsDate))
            case let (.some(lhsNumberOfEvents), .some(lhsDate), .some(rhsNumberOfEvents), .some(rhsDate)):
                return .numberOfEventsOrEndDate(min(lhsNumberOfEvents, rhsNumberOfEvents), min(lhsDate, rhsDate))
            case (.none, .none, _, _), (_, _, .none, .none):
                fatalError("An ScheduleEnd must always either have an endDate or an numberOfEvents")
            }
        }
    }
    
    
    /// <#Description#>
    public let start: Date
    /// <#Description#>
    public let dateComponents: DateComponents
    /// <#Description#>
    public let end: ScheduleEnd
    /// <#Description#>
    public let calendar: Calendar
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - start: <#start description#>
    ///   - dateComponents: <#dateComponents description#>
    ///   - calendar: <#calendar description#>
    ///   - end: <#end description#>
    public init(start: Date, dateComponents: DateComponents, end: ScheduleEnd, calendar: Calendar = .current) {
        self.start = start
        self.dateComponents = dateComponents
        self.end = end
        self.calendar = calendar
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.start = try container.decode(Date.self, forKey: .start)
        self.dateComponents = try container.decode(DateComponents.self, forKey: .dateComponents)
        
        // We allow a remote instance of default configuration to use "current" as a valid string value for a calendar and
        // set it to the `.current` calendar value.
        if try container.decode(String.self, forKey: .calendar) == "current" {
            self.calendar = .current
        } else {
            self.calendar = try container.decode(Calendar.self, forKey: .calendar)
        }
        
        self.end = try container.decode(Schedule.ScheduleEnd.self, forKey: .end)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - start: <#start description#>
    ///   - end: <#end description#>
    /// - Returns: <#description#>
    public func dates(from searchStart: Date? = nil, to end: ScheduleEnd? = nil) -> [Date] {
        let end = ScheduleEnd.minimum(end ?? self.end, self.end)
        
        var dates: [Date] = []
        var numberOfEvents = 0
        
        calendar.enumerateDates(startingAfter: self.start, matching: dateComponents, matchingPolicy: .nextTime) { result, _, stop in
            guard let result else {
                stop = true
                return
            }
            
            numberOfEvents += 1
            if result < (searchStart ?? self.start) {
                return
            }
            
            if let maxNumberOfEvents = end.numberOfEvents, numberOfEvents > maxNumberOfEvents {
                stop = true
                return
            }
            
            if let maxEndDate = end.endDate, result > maxEndDate {
                stop = true
                return
            }
            
            dates.append(result)
        }
        return dates
    }
}
