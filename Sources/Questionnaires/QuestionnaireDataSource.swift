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


/// <#Description#>
public class QuestionnaireDataSource<ComponentStandard: Standard>: AnyQuestionnaireDataSource, Component, LifecycleHandler, ObservableObjectProvider {
    @StandardActor private var standard: ComponentStandard
    private let adapter: any Adapter<QuestionnaireResponse, Identifier, ComponentStandard.BaseType, ComponentStandard.RemovalContext>
    private var continuation: AsyncStream<DataChange<QuestionnaireResponse, Identifier>>.Continuation?
    
    
    /// <#Description#>
    /// - Parameter adapter: <#adapter description#>
    public init(
        @AdapterBuilder<ComponentStandard.BaseType, ComponentStandard.RemovalContext> adapter:
        () -> (any Adapter<QuestionnaireResponse, Identifier, ComponentStandard.BaseType, ComponentStandard.RemovalContext>)
    ) {
        self.adapter = adapter()
    }
    
    /// <#Description#>
    override init() where ComponentStandard == FHIR {
        self.adapter = QuestionnaireResponseIdentityAdapter()
    }
    
    
    override public func add(_ response: QuestionnaireResponse) {
        continuation?.yield(.addition(response))
    }
    
    override public func remove(removalContext: Identifier) {
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
