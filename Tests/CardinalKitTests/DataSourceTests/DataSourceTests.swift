//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest
import XCTRuntimeAssertions


final class DataSourceTests: XCTestCase {
    private final class DataSourceTestComponentInjector<T: Hashable>: Component {
        typealias ComponentStandard = TypedMockStandard<T>
        
        
        @DynamicDependencies private var dynamicDependencies: [any Component<ComponentStandard>]
        
        
        init(_ dynamicDependencies: DynamicDependencies) {
            self._dynamicDependencies = dynamicDependencies
        }
    }
    
    final class DataSourceTestComponent<T: Identifiable, MockStandardType: Hashable>: Component, LifecycleHandler {
        typealias ComponentStandard = TypedMockStandard<MockStandardType>
        
        
        @StandardActor var standard: TypedMockStandard<MockStandardType>
        var injectedData: [DataSourceElement<T>]
        let adapter: any DataSourceRegistryAdapter<T, TypedMockStandard<MockStandardType>.BaseType>
        
        
        init(
            injectedData: [DataSourceElement<T>],
            @DataSourceRegistryAdapterBuilder<TypedMockStandard<MockStandardType>> adapter:
                () -> (any DataSourceRegistryAdapter<T, ComponentStandard.BaseType>)
        ) {
            self.injectedData = injectedData
            self.adapter = adapter()
        }
        
        
        func willFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
            let asyncStream = AsyncStream<DataSourceElement<T>> {
                guard !self.injectedData.isEmpty else {
                    return nil
                }
                
                do {
                    try await Task.sleep(nanoseconds: 5_000_000) // 0.005 seconds
                } catch {}
                return self.injectedData.removeFirst()
            }
            
            Task {
                await standard.registerDataSource(adapter.transform(asyncStream))
            }
        }
    }
    
    class DataSourceTestApplicationDelegate<T: Hashable>: CardinalKitAppDelegate {
        let dynamicDependencies: _DynamicDependenciesPropertyWrapper<TypedMockStandard<T>>
        let dataSourceExpecations: (DataSourceElement<TypedMockStandard<T>.BaseType>) async throws -> Void
        let finishedDataSourceSequence: (any TypedAsyncSequence<DataSourceElement<TypedMockStandard<T>.BaseType>>.Type) async throws -> Void
        
        
        override var configuration: Configuration {
            Configuration(standard: TypedMockStandard<T>(
                dataSourceExpecations: dataSourceExpecations,
                finishedDataSourceSequence: finishedDataSourceSequence
            )) {
                DataSourceTestComponentInjector(dynamicDependencies)
            }
        }
        
        
        init(
            dynamicDependencies: _DynamicDependenciesPropertyWrapper<TypedMockStandard<T>>,
            dataSourceExpecations: @escaping (DataSourceElement<TypedMockStandard<T>.BaseType>) async throws -> Void,
            finishedDataSourceSequence: @escaping (any TypedAsyncSequence<DataSourceElement<TypedMockStandard<T>.BaseType>>.Type) async throws -> Void
        ) {
            self.dynamicDependencies = dynamicDependencies
            self.dataSourceExpecations = dataSourceExpecations
            self.finishedDataSourceSequence = finishedDataSourceSequence
        }
    }
    
    actor IntToStringAdapterActor: DataSourceRegistryAdapter {
        typealias InputType = MockStandard.CustomDataSourceType<Int>
        typealias OutputType = MockStandard.CustomDataSourceType<String>
        
        
        func transform(
            _ asyncSequence: some TypedAsyncSequence<DataSourceElement<InputType>>
        ) async -> any TypedAsyncSequence<DataSourceElement<OutputType>> {
            asyncSequence.map { element in
                element.map(
                    element: { MockStandard.CustomDataSourceType(id: String(describing: $0.id)) },
                    id: { String(describing: $0) }
                )
            }
        }
    }
    
    actor DoubleToIntAdapterActor: SingleValueDataSourceRegistryAdapter {
        typealias InputType = MockStandard.CustomDataSourceType<Double>
        typealias OutputType = MockStandard.CustomDataSourceType<Int>
        
        
        func transform(id: InputType.ID) -> OutputType.ID {
            OutputType.ID(id)
        }
        
        func transform(element: InputType) -> OutputType {
            MockStandard.CustomDataSourceType(id: OutputType.ID(element.id))
        }
    }
    
    actor FloarToDoubleAdapterActor: SingleValueDataSourceRegistryAdapter {
        typealias InputType = MockStandard.CustomDataSourceType<Float>
        typealias OutputType = MockStandard.CustomDataSourceType<Double>
        
        
        func transform(id: InputType.ID) -> OutputType.ID {
            OutputType.ID(id)
        }
        
        func transform(element: InputType) -> OutputType {
            MockStandard.CustomDataSourceType(id: OutputType.ID(element.id))
        }
    }
    
    
    func testDataSourceRegistry() { // swiftlint:disable:this function_body_length
        let expecation = XCTestExpectation(description: "Recieved all required data source elements")
        expecation.assertForOverFulfill = true
        expecation.expectedFulfillmentCount = 3
        var dataSourceElements: [DataSourceElement<TypedMockStandard<String>.BaseType>] = []
        
        let delegate = DataSourceTestApplicationDelegate(
            dynamicDependencies: _DynamicDependenciesPropertyWrapper<TypedMockStandard<String>>(
                componentProperties: [
                    _DependencyPropertyWrapper(
                        wrappedValue: DataSourceTestComponent(
                            injectedData: [
                                .addition(MockStandard.CustomDataSourceType(id: 1)),
                                .addition(MockStandard.CustomDataSourceType(id: 2)),
                                .addition(MockStandard.CustomDataSourceType(id: 3)),
                                .removal(3),
                                .addition(MockStandard.CustomDataSourceType(id: 42))
                            ]
                        ) {
                            IntToStringAdapterActor()
                        }
                    ),
                    _DependencyPropertyWrapper(
                        wrappedValue: DataSourceTestComponent(
                            injectedData: [
                                .addition(MockStandard.CustomDataSourceType(id: 1.1)),
                                .addition(MockStandard.CustomDataSourceType(id: 2.2)),
                                .addition(MockStandard.CustomDataSourceType(id: 3.3)),
                                .removal(3.3),
                                .addition(MockStandard.CustomDataSourceType(id: 42.42))
                            ]
                        ) {
                            DoubleToIntAdapterActor()
                            IntToStringAdapterActor()
                        }
                    ),
                    _DependencyPropertyWrapper(
                        wrappedValue: DataSourceTestComponent(
                            injectedData: [
                                .addition(MockStandard.CustomDataSourceType(id: 1.1)),
                                .addition(MockStandard.CustomDataSourceType(id: 2.2)),
                                .addition(MockStandard.CustomDataSourceType(id: 3.3)),
                                .removal(3.3),
                                .addition(MockStandard.CustomDataSourceType(id: 42.42))
                            ]
                        ) {
                            FloarToDoubleAdapterActor()
                            DoubleToIntAdapterActor()
                            IntToStringAdapterActor()
                        }
                    )
                ]
            ),
            dataSourceExpecations: { dataSourceElement in
                dataSourceElements.append(dataSourceElement)
            },
            finishedDataSourceSequence: { _ in
                expecation.fulfill()
            }
        )
        
        let cardinalKit = delegate.cardinalKit
        cardinalKit.willFinishLaunchingWithOptions(UIApplication.shared, launchOptions: [:])
        
        wait(for: [expecation], timeout: 1)
        
        XCTAssertEqual(dataSourceElements.count, 15)
        XCTAssertEqual(dataSourceElements.filter { $0.id == "1" } .count, 3)
        XCTAssertEqual(dataSourceElements.filter { $0.id == "2" } .count, 3)
        XCTAssertEqual(dataSourceElements.filter { $0.id == "3" } .count, 6)
        XCTAssertEqual(dataSourceElements.filter { $0.id == "42" } .count, 3)
        
        XCTAssertEqual(
            dataSourceElements.filter {
                if case .addition(MockStandard.CustomDataSourceType(id: "3")) = $0 {
                    return true
                } else {
                    return false
                }
            }
                .count,
            3
        )
        XCTAssertEqual(
            dataSourceElements.filter {
                if case .removal("3") = $0 {
                    return true
                } else {
                    return false
                }
            }
                .count,
            3
        )
    }
}
