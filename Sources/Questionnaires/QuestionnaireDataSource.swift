//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import FHIR
import ModelsR4
import SwiftUI


/// Maps `Questionnaires` returned from the ``QuestionnaireView`` to the `Standard` of the CardinalKit application.
///
/// Use the ``QuestionnaireDataSource/init(adapter:)`` initializer to add the data source to your `Configuration`.
/// You can use the ``QuestionnaireDataSource/init()`` initializer of you use the FHIR standard in your CardinalKit application:
/// ```
/// class ExampleAppDelegate: CardinalKitAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             QuestionnaireDataSource()
///         }
///     }
/// }
/// ```
public class QuestionnaireDataSource<ComponentStandard: Standard>: AnyQuestionnaireDataSource, Component, LifecycleHandler, ObservableObjectProvider {
    @StandardActor private var standard: ComponentStandard
    private let adapter: any Adapter<QuestionnaireResponse, Resource.ID, ComponentStandard.BaseType, ComponentStandard.RemovalContext>
    private var continuation: AsyncStream<DataChange<QuestionnaireResponse, Resource.ID>>.Continuation?
    
    
    /// - Parameter adapter: An `Adapter` to define the mapping of a `QuestionnaireResponse`s to the component's standard's base type.
    public init(
        @AdapterBuilder<ComponentStandard.BaseType, ComponentStandard.RemovalContext> adapter:
        () -> (any Adapter<QuestionnaireResponse, Resource.ID, ComponentStandard.BaseType, ComponentStandard.RemovalContext>)
    ) {
        self.adapter = adapter()
    }
    
    /// ``QuestionnaireDataSource`` initializer with no need for an adapter if the `ComponentStandard` is the `FHIR` standard.
    override init() where ComponentStandard == FHIR {
        self.adapter = QuestionnaireResponseIdentityAdapter()
    }
    
    
    override public func add(_ response: QuestionnaireResponse) {
        continuation?.yield(.addition(response))
    }
    
    override public func remove(removalContext: Resource.ID) {
        continuation?.yield(.removal(removalContext))
    }
    
    
    public func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        _Concurrency.Task {
            await standard.registerDataSource(
                adapter.transform(
                    AsyncStream { continuation in
                        self.continuation = continuation
                    }
                )
            )
        }
    }
}
