//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


private actor TwoDataSourceRegistryAdapterChain<
        InputType: Identifiable,
        IntermediateType: Identifiable,
        OutputType: Identifiable
    >: Actor, DataSourceRegistryAdapter {
    let firstDataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, IntermediateType>
    let secondDataSourceRegistryAdapter: any DataSourceRegistryAdapter<IntermediateType, OutputType>
    
    
    init(
        firstDataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, IntermediateType>,
        secondDataSourceRegistryAdapter: any DataSourceRegistryAdapter<IntermediateType, OutputType>
    ) {
        self.firstDataSourceRegistryAdapter = firstDataSourceRegistryAdapter
        self.secondDataSourceRegistryAdapter = secondDataSourceRegistryAdapter
    }
    
    
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputType>>
    ) async -> any TypedAsyncSequence<DataChange<OutputType>> {
        let firstDataSourceRegistryTransformation = await firstDataSourceRegistryAdapter.transform(asyncSequence)
        return await secondDataSourceRegistryAdapter.transform(firstDataSourceRegistryTransformation)
    }
}

private actor ThreeDataSourceRegistryAdapterChain<
        InputType: Identifiable,
        IntermediateTypeOne: Identifiable,
        IntermediateTypeTwo: Identifiable,
        OutputType: Identifiable
    >: Actor, DataSourceRegistryAdapter {
    let firstDataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, IntermediateTypeOne>
    let secondDataSourceRegistryAdapter: any DataSourceRegistryAdapter<IntermediateTypeOne, IntermediateTypeTwo>
    let thirdDataSourceRegistryAdapter: any DataSourceRegistryAdapter<IntermediateTypeTwo, OutputType>
    
    
    init(
        firstDataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, IntermediateTypeOne>,
        secondDataSourceRegistryAdapter: any DataSourceRegistryAdapter<IntermediateTypeOne, IntermediateTypeTwo>,
        thirdDataSourceRegistryAdapter: any DataSourceRegistryAdapter<IntermediateTypeTwo, OutputType>
    ) {
        self.firstDataSourceRegistryAdapter = firstDataSourceRegistryAdapter
        self.secondDataSourceRegistryAdapter = secondDataSourceRegistryAdapter
        self.thirdDataSourceRegistryAdapter = thirdDataSourceRegistryAdapter
    }
    
    
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputType>>
    ) async -> any TypedAsyncSequence<DataChange<OutputType>> {
        let firstDataSourceRegistryTransformation = await firstDataSourceRegistryAdapter.transform(asyncSequence)
        let secondDataSourceRegistryTransformation = await secondDataSourceRegistryAdapter.transform(firstDataSourceRegistryTransformation)
        return await thirdDataSourceRegistryAdapter.transform(secondDataSourceRegistryTransformation)
    }
}


/// A function builder used to generate data source registry adapter chains.
@resultBuilder
public enum DataSourceRegistryAdapterBuilder<S: Standard> {
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock<InputType: Identifiable, OutputType: Identifiable>(
        _ dataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, OutputType>
    ) -> any DataSourceRegistryAdapter<InputType, OutputType> where OutputType == S.BaseType {
        dataSourceRegistryAdapter
    }
    
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock<InputType: Identifiable, Intermediate: Identifiable, OutputType: Identifiable>(
        _ firstDataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, Intermediate>,
        _ secondDataSourceRegistryAdapter: any DataSourceRegistryAdapter<Intermediate, OutputType>
    ) -> any DataSourceRegistryAdapter<InputType, OutputType> where OutputType == S.BaseType {
        TwoDataSourceRegistryAdapterChain(
            firstDataSourceRegistryAdapter: firstDataSourceRegistryAdapter,
            secondDataSourceRegistryAdapter: secondDataSourceRegistryAdapter
        )
    }
    
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock<InputType: Identifiable, Intermediate1: Identifiable, Intermediate2: Identifiable, OutputType: Identifiable>(
        _ firstDataSourceRegistryAdapter: any DataSourceRegistryAdapter<InputType, Intermediate1>,
        _ secondDataSourceRegistryAdapter: any DataSourceRegistryAdapter<Intermediate1, Intermediate2>,
        _ thirdDataSourceRegistryAdapter: any DataSourceRegistryAdapter<Intermediate2, OutputType>
    ) -> any DataSourceRegistryAdapter<InputType, OutputType> where OutputType == S.BaseType {
        ThreeDataSourceRegistryAdapterChain(
            firstDataSourceRegistryAdapter: firstDataSourceRegistryAdapter,
            secondDataSourceRegistryAdapter: secondDataSourceRegistryAdapter,
            thirdDataSourceRegistryAdapter: thirdDataSourceRegistryAdapter
        )
    }
}
