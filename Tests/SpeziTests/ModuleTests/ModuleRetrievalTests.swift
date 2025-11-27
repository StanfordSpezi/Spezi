//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) @testable import Spezi
import Testing

@MainActor
@Suite("Module Retrieval")
struct ModuleRetrievalTests {
    private class BaseModule: Module {}
    
    private class DerivedModule: BaseModule {}
    
    @Test("Retrieves module by exact type")
    func retrieveByExactType() {
        let baseModule = BaseModule()
        let derivedModule = DerivedModule()
        
        let spezi = Spezi(standard: DefaultStandard(), modules: [baseModule, derivedModule])
        
        #expect(spezi.module(BaseModule.self) === baseModule)
        #expect(spezi.module(DerivedModule.self) === derivedModule)
    }
    
    @Test("Retrieves module using type inference")
    func retrieveWithTypeInference() {
        let baseModule = BaseModule()
        
        let spezi = Spezi(standard: DefaultStandard(), modules: [baseModule])
        
        let retrieved: BaseModule? = spezi.module()
        #expect(retrieved === baseModule)
    }
    
    @Test("Returns nil for unconfigured module")
    func retrieveUnconfiguredModule() {
        let spezi = Spezi(standard: DefaultStandard(), modules: [])
        
        let missing: BaseModule? = spezi.module()
        #expect(missing == nil)
    }
    
    @Test("Base type lookup with only derived module configured")
    func retrieveDerivedByBaseType() {
        let derivedModule = DerivedModule()
        
        let spezi = Spezi(standard: DefaultStandard(), modules: [derivedModule])
        
        // This tests the inheritance lookup behavior
        // Current behavior: returns nil (looks for exact BaseModule)
        let retrieved: BaseModule? = spezi.module()
        
        #expect(retrieved == nil, "Current behavior: base type lookup doesn't find derived modules")
    }
    
    @Test("Derived module retains runtime type when upcast")
    func derivedModuleRetainsRuntimeType() throws {
        let derivedModule = DerivedModule()
        
        let spezi = Spezi(standard: DefaultStandard(), modules: [derivedModule])
        
        let retrieved: BaseModule = try #require(spezi.module(DerivedModule.self))
        
        #expect(retrieved === derivedModule)
        #expect(type(of: retrieved) == DerivedModule.self)
    }
}
