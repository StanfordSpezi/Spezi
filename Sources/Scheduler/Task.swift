//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A ``Task`` defines an instruction that is scheduled one to multiple times as defined by the ``Task/schedule`` property.
///
/// A ``Task`` can have an additional ``Task/context`` associated with it that can be used to carry application-specific context.
public final class Task<Context: Codable & Sendable>: Codable, Identifiable, Hashable, ObservableObject, @unchecked Sendable, EventContext {
    enum CodingKeys: CodingKey {
        case id
        case title
        case description
        case schedule
        case context
        case completedEvents
    }
    
    
    /// The unique identifier of the ``Task``.
    public let id: UUID
    /// The title of the ``Task``.
    public let title: String
    /// The description of the ``Task``.
    public let description: String
    /// The description of the ``Task`` as defined by a ``Schedule`` instance.
    public let schedule: Schedule
    /// The customized context of the ``Task``.
    public let context: Context
    @Published var completedEvents: [Date: Event]
    
    
    /// Creates a new ``Task`` instance.
    /// - Parameters:
    ///   - title: The title of the ``Task``.
    ///   - description: The description of the ``Task``.
    ///   - schedule: The description of the ``Task`` as defined by a ``Schedule`` instance.
    ///   - context: The customized context of the ``Task``.
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
    
    
    /// Returns all ``Event``s corresponding to a ``Task`` withi the `start` and `end` parameters.
    /// - Parameters:
    ///   - start: The start of the requested series of `Event`s. The start date of the ``Task/schedule`` is used if the start date is before the ``Task/schedule``'s start date.
    ///   - end: The end of the requested series of `Event`s. The end (number of events or date) of the ``Task/schedule`` is used if the start date is after the ``Task/schedule``'s end.
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
