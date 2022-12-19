//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// <#Description#>
public final class Task<Context: Codable & Sendable>: Codable, Identifiable, Hashable, ObservableObject, @unchecked Sendable, EventContext {
    enum CodingKeys: CodingKey {
        case id
        case title
        case description
        case schedule
        case context
        case completedEvents
    }
    
    
    /// <#Description#>
    public let id: UUID
    /// <#Description#>
    public let title: String
    /// <#Description#>
    public let description: String
    /// <#Description#>
    public let schedule: Schedule
    /// <#Description#>
    public let context: Context
    @Published var completedEvents: [Date: Event]
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - description: <#description description#>
    ///   - schedule: <#schedule description#>
    ///   - context: <#context description#>
    public init(title: String, description: String, schedule: Schedule, context: Context) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.schedule = schedule
        self.context = context
        self.completedEvents = [:]
    }
    
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.schedule = try container.decode(Schedule.self, forKey: .schedule)
        self.context = try container.decode(Context.self, forKey: .context)
        self.completedEvents = try container.decode([Date: Event].self, forKey: .completedEvents)
        
        for completedEvent in completedEvents.values {
            completedEvent.eventContext = self
        }
    }
    
    
    public static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - start: <#start description#>
    ///   - end: <#end description#>
    /// - Returns: <#description#>
    public func events(from start: Date? = nil, to end: Schedule.ScheduleEnd? = nil) -> [Event] {
        let dates = schedule.dates(from: start, to: end)
        
        return dates
            .map { date in
                completedEvents[date] ?? Event(scheduledAt: date, eventsContainer: self)
            }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(context, forKey: .context)
        try container.encode(completedEvents, forKey: .completedEvents)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
