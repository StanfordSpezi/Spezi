//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


///// <#Description#>
// public actor IdentityFirestoreElementAdapter<InputType: FirestoreElement>: FirestoreElementAdapter {
//    public typealias OutputType = AnyFirestoreElement
//    
//    
//    /// <#Description#>
//    public struct AnyFirestoreElement: FirestoreElement {
//        fileprivate let element: any FirestoreElement
//        
//        static var collectionPath
//        
//        public static var collectionPath: String {
//            collectionPath(element)
//        }
//        
//        public var id: String {
//            element.id
//        }
//        
//        
//        fileprivate init(element: some FirestoreElement) {
//            self.element = element
//        }
//        
//        
//        public func encode(to encoder: Encoder) throws {
//            try element.encode(to: encoder)
//        }
//        
//        private static func collectionPath(fromElement element: some FirestoreElement) -> String {
//        }
//    }
//    
//    
//    /// <#Description#>
//    public init() {}
//
//
//    public func transform(element: InputType) -> AnyFirestoreElement {
//        AnyFirestoreElement(element: element)
//    }
//
//    public func transform(id: InputType.ID) -> String {
//        "\(InputType.collectionPath)/\(id.description)"
//    }
// }
