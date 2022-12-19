//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// An  ``Event`` describes a unique point in time when a ``Task`` is scheduled. Use events to display the recurring nature of a ``Task`` to a user.
///
/// Use the  ``Event/complete(_:)`` and ``Event/toggle()`` functions to mark an Event as complete. You can access the scheduled date of an
/// event using ``Event/scheduledAt`` and the completed date using the ``Event/completedAt`` properties.
public final class Event: Codable, Identifiable, Hashable, @unchecked Sendable {
    enum CodingKeys: String, CodingKey {
        // We use the underscore as the corresponding property `_scheduledAt` uses an underscore as it is a private property.
        // swiftlint:disable:next identifier_name
        case _scheduledAt = "scheduledAt"
        case completedAt
    }
    
    
    private let lock = Lock()
    private let _scheduledAt: Date
    /// The date when the ``Event`` was completed.
    public private(set) var completedAt: Date?
    weak var eventContext: EventContext?
    
    
    /// The date when the ``Event`` is scheduled at.
    public var scheduledAt: Date {
        guard let eventsContainer = eventContext else {
            return _scheduledAt
        }
        
        let timeZoneDifference = TimeInterval(
            eventsContainer.schedule.calendar.timeZone.secondsFromGMT(for: .now) - Calendar.current.timeZone.secondsFromGMT(for: .now)
        )
        return _scheduledAt.addingTimeInterval(timeZoneDifference)
    }
    
    /// Indictes if the ``Event`` is complete.
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
    
    /// Use this function to mark an ``Event`` as complete or incomplete.
    /// - Parameter newValue: The new state of the ``Event``.
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
    
    
    /// Toggle the ``Event``'s ``Event/complete`` state.
    public func toggle() async {
        await complete(!complete)
    }
}
