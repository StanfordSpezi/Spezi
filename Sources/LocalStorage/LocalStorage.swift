//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Foundation
import SecureStorage
import Security


/// <#Description#>
public class LocalStorage<ComponentStandard: Standard>: Module {
    private let encryptionAlgorithm: SecKeyAlgorithm = .eciesEncryptionCofactorX963SHA256AESGCM
    @Dependency private var secureStorage = SecureStorage()
    
    
    private var localStorageDirectory: URL {
        // We store the files in the application support directory as described in
        // https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let localStoragePath = paths[0].appendingPathComponent("LocalStorage")
        if !FileManager.default.fileExists(atPath: localStoragePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: localStoragePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        return localStoragePath
    }
    
    
    /// <#Description#>
    public init() {}
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - element: <#element description#>
    ///   - storageKey: <#storageKey description#>
    ///   - settings: <#settings description#>
    public func store<C: Codable>(
        _ element: C,
        storageKey: String? = nil,
        settings: LocalStorageSetting = .encrypedUsingKeyChain()
    ) throws {
        var fileURL = fileURL(from: storageKey, type: C.self)
        let fileManager = FileManager()
        let fileExistsAlready = fileManager.fileExists(atPath: fileURL.absoluteString)
        
        // Called at the end of each execution path
        // We can not use defer as the function can potentlially throw an error.
        func setResourceValues() throws {
            do {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try fileURL.setResourceValues(resourceValues)
            } catch {
                // Revert a written file if it did not exist before.
                if !fileExistsAlready {
                    try fileManager.removeItem(atPath: fileURL.absoluteString)
                }
                throw LocalStorageError.couldNotExcludedFromBackup
            }
        }
        
        let data = try JSONEncoder().encode(element)
        
        
        // Determin if the data should be encryped or not:
        guard let keys = try settings.keys(from: secureStorage) else {
            // No encryption:
            try data.write(to: fileURL)
            try setResourceValues()
            return
        }
        
        // Encryption enabled:
        guard SecKeyIsAlgorithmSupported(keys.publicKey, .encrypt, encryptionAlgorithm) else {
            throw LocalStorageError.encyptionNotPossible
        }

        var encryptError: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(keys.publicKey, encryptionAlgorithm, data as CFData, &encryptError) as Data? else {
            throw LocalStorageError.encyptionNotPossible
        }
        
        try encryptedData.write(to: fileURL)
        try setResourceValues()
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - storageKey: <#storageKey description#>
    ///   - settings: <#settings description#>
    /// - Returns: <#description#>
    public func read<C: Codable>(
        _ type: C.Type = C.self,
        storageKey: String? = nil,
        settings: LocalStorageSetting = .encrypedUsingKeyChain()
    ) throws -> C {
        let data = try Data(contentsOf: fileURL(from: storageKey, type: C.self))
        
        // Determin if the data should be decrypted or not:
        guard let keys = try settings.keys(from: secureStorage) else {
            return try JSONDecoder().decode(C.self, from: data)
        }
        
        guard SecKeyIsAlgorithmSupported(keys.privateKey, .decrypt, encryptionAlgorithm) else {
            throw LocalStorageError.decryptionNotPossible
        }

        var decryptError: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(keys.privateKey, encryptionAlgorithm, data as CFData, &decryptError) as Data? else {
            throw LocalStorageError.decryptionNotPossible
        }
        
        return try JSONDecoder().decode(C.self, from: decryptedData)
    }
    
    
    private func fileURL<C>(from storageKey: String? = nil, type: C.Type = C.self) -> URL {
        let storageKey = storageKey ?? String(describing: C.self)
        return localStorageDirectory.appending(path: storageKey).appendingPathExtension("localstorage")
    }
}
