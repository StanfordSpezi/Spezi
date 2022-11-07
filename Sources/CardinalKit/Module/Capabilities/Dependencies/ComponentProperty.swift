//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


protocol ComponentProperty<PropertyStandard>: DependencyDescriptor, AnyObject {
    associatedtype ComponentType: Component where ComponentType.ComponentStandard == PropertyStandard
    
    
    var defaultValue: () -> ComponentType { get }
    var dependency: ComponentType? { get set }
}
