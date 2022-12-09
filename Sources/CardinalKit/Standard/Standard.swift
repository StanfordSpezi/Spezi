//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Standard`` defines a common representation of resources using by different `CardinalKit` components.
public protocol Standard<BaseType>: Actor, Component, DataSourceRegistry where ComponentStandard == Self { }
