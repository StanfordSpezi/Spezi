# Scheduling A Task

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Create and schedule a task.

## Overview

The Scheduler module can be used to create and schedule tasks for your users to complete.

In the following example, we will create a task for a survey to be taken daily, starting now, for 7 days.

```swift
let surveyTask = Task(
    title: "Survey",
    description: "Take a survey",
    schedule: Schedule(
        start: .now,
        dateComponents: .init(day: 1), // daily
        end: .numberOfEvents(7)
    ),
    context: "This is a test context"
)
```

Now, we will use the scheduler to schedule our task. Note that the scheduler requires a `Standard` to be defined.

```swift
let scheduler = Scheduler<SchedulerTestsStandard, String>(tasks: [surveyTask])
```

## Topics

### Components

- ``Schedule``
- ``Task``
