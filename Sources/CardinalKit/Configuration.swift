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


public protocol AnyConfiguration {
    func configureAny(cardinalKit: Any)
}

extension Array: AnyConfiguration where Element == AnyConfiguration {
    public func configureAny(cardinalKit: Any) {
        forEach {
            $0.configureAny(cardinalKit: cardinalKit)
        }
    }
}

public protocol Configuration: AnyConfiguration {
    associatedtype ResourceRepresentation: Standard
    
    func configure(cardinalKit: CardinalKit<ResourceRepresentation>)
}

extension Configuration {
    public func configureAny(cardinalKit: Any) {
        guard let typedCardinalKit = cardinalKit as? CardinalKit<ResourceRepresentation> else {
            return
        }
        
        self.configure(cardinalKit: typedCardinalKit)
    }
}
