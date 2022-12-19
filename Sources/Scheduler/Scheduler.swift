//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation


public class Scheduler<ComponentStandard: Standard, Context: Codable>: Module {
    private(set) var tasks: [Task<Context>]
    private var timers: [Timer] = []
    
    
    init(tasks: [Task<Context>]) {
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
    
    
    func schedule(task: Task<Context>) {
        let futureEvents = task.events(from: .now, to: .endDate(.distantFuture))
        timers.reserveCapacity(timers.count + futureEvents.count)
        
        for futureEvent in futureEvents {
            Timer.scheduledTimer(
                withTimeInterval: futureEvent.scheduledAt.distance(to: .now.addingTimeInterval(0.01)),
                repeats: false
            ) { [weak self] timer in
                timer.invalidate()
                self?.objectWillChange.send()
            }
        }
        
        tasks.append(task)
    }
    
    
    @objc
    private func timeZoneChanged() async {
        objectWillChange.send()
    }
    
    
    deinit {
        for timer in timers {
            timer.invalidate()
        }
    }
}
