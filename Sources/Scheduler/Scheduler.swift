//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Combine
import Foundation


/// The ``Scheduler/Scheduler`` module allows the scheduling and observation of ``Task``s adhering to a specific ``Schedule``.
///
/// Use the ``Scheduler/Scheduler/init(tasks:)`` initializer or the ``Scheduler/Scheduler/schedule(task:)`` function
/// to schedule tasks that you can obtain using the ``Scheduler/Scheduler/tasks`` property.
/// You can use the ``Scheduler/Scheduler`` as an `ObservableObject` to automatically update your SwiftUI views when new events are emitted or events change.
public class Scheduler<ComponentStandard: Standard, Context: Codable>: Equatable, Module {
    public private(set) var tasks: [Task<Context>]
    private var timers: [Timer] = []
    private var cancellables: Set<AnyCancellable> = []
    
    
    /// Creates a new ``Scheduler`` module.
    /// - Parameter tasks: The initial set of ``Task``s.
    public init(tasks: [Task<Context>] = []) {
        self.tasks = []
        self.tasks.reserveCapacity(tasks.count)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(timeZoneChanged),
            name: Notification.Name.NSSystemTimeZoneDidChange,
            object: nil
        )
        
        for task in tasks {
            schedule(task: task)
        }
    }
    
    
    public static func == (lhs: Scheduler<ComponentStandard, Context>, rhs: Scheduler<ComponentStandard, Context>) -> Bool {
        lhs.tasks == rhs.tasks
    }
    
    
    /// Schedule a new ``Task`` in the ``Scheduler`` module.
    /// - Parameter task: The new ``Task`` instance that should be scheduled.
    public func schedule(task: Task<Context>) {
        let futureEvents = task.events(from: .now, to: .endDate(.distantFuture))
        timers.reserveCapacity(timers.count + futureEvents.count)
        
        for futureEvent in futureEvents {
            Timer.scheduledTimer(
                withTimeInterval: Date.now.distance(to: futureEvent.scheduledAt),
                repeats: false
            ) { [weak self] timer in
                timer.invalidate()
                let `self` = self
                _Concurrency.Task { @MainActor in
                    self?.objectWillChange.send()
                }
            }
        }
        
        task.objectWillChange
            .sink {
                _Concurrency.Task { @MainActor in
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
        tasks.append(task)
    }
    
    
    @objc
    private func timeZoneChanged() async {
        _Concurrency.Task { @MainActor in
            self.objectWillChange.send()
        }
    }
    
    
    deinit {
        for timer in timers {
            timer.invalidate()
        }
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}
