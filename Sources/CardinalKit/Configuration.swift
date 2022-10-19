//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
//
// This code is based on the Apodini (https://github.com/Apodini/Apodini) project.
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the Apodini project authors
//
// SPDX-License-Identifier: MIT
//


public protocol Configuration {
    func configure(_ any: Any) -> ()
}

class ConfigurationWrapper: Configuration {
    private let configure: (Any) -> ()
    
    
    init<C: StandardBasedConfiguration>(_ configuration: C) {
        self.configure = { any in
            guard let cardinalKit = any as? CardinalKit<C.ResourceRepresentation> else {
                fatalError(
                    """
                    Error in the internal CardinalKit structure.
                    A `Configuration` for a `CardinalKit` instance must match its internal `Standard`
                    """
                )
            }
            configuration.configure(cardinalKit)
        }
    }
    
    func configure(_ any: Any) {
        configure(any)
    }
}


/// `Configuration`s are used to setup and configure different aspects of a ``CardinalKit/CardinalKit`` instance.
public protocol StandardBasedConfiguration: Configuration {
    associatedtype ResourceRepresentation: Standard
    
    
    /// The `configure(_: CardinalKit)` method can be used to perform any setup on a ``CardinalKit/CardinalKit`` instance.
    /// - Parameter cardinalKit: The configurable ``CardinalKit/CardinalKit`` instance.
    func configure(_ cardinalKit: CardinalKit<ResourceRepresentation>)
}


extension StandardBasedConfiguration {
    public func configure(_ any: Any) {
        ConfigurationWrapper(self).configure(any)
    }
}


extension Array: Configuration where Element: StandardBasedConfiguration {
    public func configure(_ any: Any) {
        for anyConfiguration in self {
            anyConfiguration.configure(any)
        }
    }
}


extension Array: StandardBasedConfiguration where Element: StandardBasedConfiguration {
    public typealias ResourceRepresentation = Element.ResourceRepresentation
    
    
    public func configure(_ cardinalKit: CardinalKit<Element.ResourceRepresentation>) {
        for configuration in self {
            configuration.configure(cardinalKit)
        }
    }
}
