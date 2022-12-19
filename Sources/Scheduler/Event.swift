//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// <#Description#>
public final class Event: Codable, Identifiable, Hashable, @unchecked Sendable {
    enum CodingKeys: String, CodingKey {
        // We use the underscore as the corresponding property `_scheduledAt` uses an underscore as it is a private property.
        // swiftlint:disable:next identifier_name
        case _scheduledAt = "scheduledAt"
        case completedAt
    }
    
    
    private let lock = Lock()
    private let _scheduledAt: Date
    private(set) var completedAt: Date?
    weak var eventContext: EventContext?
    
    
    /// <#Description#>
    public var scheduledAt: Date {
        guard let eventsContainer = eventContext else {
            return _scheduledAt
        }
        
        let timeZoneDifference = TimeInterval(
            eventsContainer.schedule.calendar.timeZone.secondsFromGMT(for: .now) - Calendar.current.timeZone.secondsFromGMT(for: .now)
        )
        return _scheduledAt.addingTimeInterval(timeZoneDifference)
    }
    
    /// <#Description#>
    public var complete: Bool {
        completedAt != nil
    }
    
    public var id: String {
        "\(eventContext?.id.uuidString ?? "").\(_scheduledAt.description)"
    }
    
    
    init(scheduledAt: Date, eventsContainer: EventContext) {
        self._scheduledAt = scheduledAt
        self.eventContext = eventsContainer
    }
    
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.eventContext?.id == rhs.eventContext?.id && lhs.scheduledAt == rhs.scheduledAt
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(eventContext?.id)
        hasher.combine(_scheduledAt)
    }
    
    /// <#Description#>
    /// - Parameter newValue: <#newValue description#>
    public func complete(_ newValue: Bool) async {
        await lock.enter {
            if newValue {
                completedAt = Date()
                eventContext?.completedEvents[_scheduledAt] = self
            } else {
                eventContext?.completedEvents[_scheduledAt] = nil
                completedAt = nil
            }
        }
    }
    
    
    public func toggle() async {
        await complete(!complete)
    }
}
