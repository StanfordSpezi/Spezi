//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation


class CompletedEvent: Codable {
    let scheduledAt: Date
    let completedAt: Date
}


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
    let start: Date
    let end: Date?
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
