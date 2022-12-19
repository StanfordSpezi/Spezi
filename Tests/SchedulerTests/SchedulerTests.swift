//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Scheduler
import XCTest


actor SchedulerTestsStandard: Standard {
    typealias BaseType = CustomDataSourceType<String>
    
    
    struct CustomDataSourceType<T: Hashable>: Equatable, Identifiable {
        let id: T
    }
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType>>) { }
}


final class SchedulerTests: XCTestCase {
    func testExample() throws {
        let numberOfEvents = 6
        
        let testTask = Task(
            title: "Test Task",
            description: "This is a test task",
            schedule: Schedule(
                start: .now,
                dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                end: .numberOfEvents(numberOfEvents)
            ),
            context: "This is a test context"
        )
        let scheduler = Scheduler<SchedulerTestsStandard, String>(tasks: [testTask])
        
        
        let expectation = XCTestExpectation(description: "Get Updates for all scheduled events.")
        expectation.expectedFulfillmentCount = numberOfEvents
        expectation.assertForOverFulfill = true
        
        var eventCount = 0
        
        let cancellable = scheduler.objectWillChange.sink {
            eventCount += 1
            XCTAssertEqual(eventCount, scheduler.tasks.first?.events(to: .endDate(.now)).count)
            XCTAssertEqual(numberOfEvents - eventCount, scheduler.tasks.first?.events(from: .now).count)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: TimeInterval(numberOfEvents + 3))
        
        cancellable.cancel()
    }
    
    
    func testCompleteEvents() throws {
        let numberOfEvents = 6
        
        let testTask = Task(
            title: "Test Task",
            description: "This is a test task",
            schedule: Schedule(
                start: .now,
                dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                end: .numberOfEvents(numberOfEvents)
            ),
            context: "This is a test context"
        )
        let testTask2 = Task(
            title: "Test Task 2",
            description: "This is a second test task",
            schedule: Schedule(
                start: .now.addingTimeInterval(10),
                dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                end: .numberOfEvents(numberOfEvents)
            ),
            context: "This is a second test context"
        )
        let scheduler = Scheduler<SchedulerTestsStandard, String>(tasks: [testTask, testTask2])
        
        let expectation = XCTestExpectation(description: "Get Updates for all scheduled events.")
        expectation.expectedFulfillmentCount = 12
        expectation.assertForOverFulfill = true
        
        let events = scheduler.tasks.flatMap { $0.events() }
        for event in events {
            _Concurrency.Task {
                await event.complete(true)
                expectation.fulfill()
            }
        }
        
        sleep(1)
        
        XCTAssert(events.allSatisfy { $0.complete })
        
        wait(for: [expectation], timeout: TimeInterval(2))
    }
}
