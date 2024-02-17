//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


@propertyWrapper
public class _ApplicationPropertyWrapper<Value> { // swiftlint:disable:this type_name
    private let keyPath: KeyPath<Spezi, Value>

    private weak var spezi: Spezi?


    public var wrappedValue: Value {
        guard let spezi else {
            preconditionFailure("Underlying Spezi instance was not yet injected. @Application cannot be accessed within the initializer!")
        }
        return spezi[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<Spezi, Value>) {
        self.keyPath = keyPath
    }
}


extension _ApplicationPropertyWrapper: SpeziPropertyWrapper {
    func inject(spezi: Spezi) {
        self.spezi = spezi
    }
}


extension Module {
    public typealias Application<Value> = _ApplicationPropertyWrapper<Value>
}
