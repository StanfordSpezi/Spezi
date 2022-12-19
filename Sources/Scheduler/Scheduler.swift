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


public class Scheduler<ComponentStandard: Standard, Context: Codable>: Module {
    public private(set) var tasks: [Task<Context>]
    private var timers: [Timer] = []
    private var cancellables: Set<AnyCancellable> = []
    
    
    /// <#Description#>
    /// - Parameter tasks: <#tasks description#>
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
    
    
    /// <#Description#>
    /// - Parameter task: <#task description#>
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
