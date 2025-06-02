//
//  ServiceModule.swift
//  Spezi
//
//  Created by Andreas Bauer on 03.06.25.
//


/// A Module that hooks into the structured concurrency service lifecycle of the application.
public protocol ServiceModule: Module, Sendable {
    func run() async
}


extension ServiceModule {
    var moduleId: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
