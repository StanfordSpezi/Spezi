//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


//extension Component {
//    // A documentation for this methodd exists in the `Component` type which SwiftLint doesn't recognize.
//    // swiftlint:disable:next missing_docs
//    public func configure() {}
//}


//extension Component {
//    func saveInTypedCollection(cardinalKit: CardinalKit<ComponentStandard>) {
//        if let typedCollectionKey = self as? (any TypedCollectionKey) {
//            Self.save(typedCollectionKey: typedCollectionKey, saveInTypedCollectionOfCardinalKit: cardinalKit)
//        }
//    }
//
//    private static func save<T: TypedCollectionKey>(
//        typedCollectionKey: T,
//        saveInTypedCollectionOfCardinalKit cardinalKit: CardinalKit<ComponentStandard>
//    ) {
//        cardinalKit.typedCollection.set(T.self, to: typedCollectionKey as? T.Value)
//    }
//}
