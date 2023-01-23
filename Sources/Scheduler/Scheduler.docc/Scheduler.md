# ``Scheduler``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

Allows you to schedule and observe tasks for your users to complete, such as taking surveys.

## Overview

The Scheduler module allows the scheduling and observation of ``Task``s adhering to a specific ``Schedule``. 

You can use the ``Scheduler/Scheduler`` as an `ObservableObject` to automatically update your SwiftUI views when any new events are emitted or events change.

## Topics

### Using the Scheduler

- <doc:SchedulingATask>

### Components

- ``Schedule``
- ``Task``
- ``Event``
