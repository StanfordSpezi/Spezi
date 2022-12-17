//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation


class Event: Codable, Identifiable, Hashable {
    enum CodingKeys: CodingKey {
        case scheduledAt
        case completedAt
    }
    
    
    let scheduledAt: Date
    var completedAt: Date?
    weak var task: EventsContainer?
    
    
    var complete: Bool {
        get {
            completedAt != nil
        }
        set {
            if newValue {
                completedAt = Date()
            } else {
                completedAt = nil
            }
        }
    }
    
    var id: Date {
        scheduledAt
    }
    
    
    init(scheduledAt: Date, task: EventsContainer) {
        self.scheduledAt = scheduledAt
        self.task = task
    }
    
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.scheduledAt == rhs.scheduledAt
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(scheduledAt)
    }
}


class Schedule: Codable {
    enum ScheduleEnd: Codable {
        case numberOfEvents(Int)
        case endDate(Date)
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
            switch (lhs.numberOfEvents, lhs.endDate, lhs.numberOfEvents, rhs.endDate) {
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
    
    
    let start: Date
    let dateComponents: DateComponents
    let end: ScheduleEnd
    
    
    init(start: Date, dateComponents: DateComponents, end: ScheduleEnd) {
        self.start = start
        self.dateComponents = dateComponents
        self.end = end
    }
    
    
    func dates(from start: Date? = nil, to end: ScheduleEnd? = nil) -> [Date] {
        let start = max(start ?? self.start, self.start)
        let end = ScheduleEnd.minimum(end ?? self.end, self.end)
        
        var dates: [Date] = []
        Calendar.current.enumerateDates(startingAfter: start, matching: dateComponents, matchingPolicy: .nextTime) { result, _, stop in
            guard let result else {
                return
            }
            
            if let maxNumberOfEvents = end.numberOfEvents, dates.count > maxNumberOfEvents {
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


protocol EventsContainer: AnyObject {
    var completedEvents: Set<Event> { get set }
}


class Task<Context: Codable>: Codable, Identifiable, Hashable, EventsContainer {
    let id: UUID
    let title: String
    let description: String
    let schedule: Schedule
    let context: Context
    var completedEvents: Set<Event>
    
    
    init(title: String, description: String, schedule: Schedule, context: Context) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.schedule = schedule
        self.context = context
        self.completedEvents = []
    }
    
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Task<Context>.CodingKeys> = try decoder.container(keyedBy: Task<Context>.CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: Task<Context>.CodingKeys.id)
        self.title = try container.decode(String.self, forKey: Task<Context>.CodingKeys.title)
        self.description = try container.decode(String.self, forKey: Task<Context>.CodingKeys.description)
        self.schedule = try container.decode(Schedule.self, forKey: Task<Context>.CodingKeys.schedule)
        self.context = try container.decode(Context.self, forKey: Task<Context>.CodingKeys.context)
        self.completedEvents = try container.decode(Set<Event>.self, forKey: Task<Context>.CodingKeys.completedEvents)
        
        for completedEvent in completedEvents {
            completedEvent.task = self
        }
    }
    
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


public actor Scheduler<ComponentStandard: Standard, Context: Codable>: Module {
    var tasks: [Task<Context>]
    
    
    init(tasks: [Task<Context>]) {
        self.tasks = tasks
    }
}
