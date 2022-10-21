//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


class LocalStorage<ComponentStandard: Standard>: Module {
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
    
    
    func store<C: Codable>(_ element: C, storageKey: String? = nil) throws {
        let storageKey = storageKey ?? String(describing: C.self)
        var fileURL = localStorageDirectory.appending(path: storageKey).appendingPathExtension("localstorage")
        
        let data = try JSONEncoder().encode(element)
        try data.write(to: fileURL)
        
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try? fileURL.setResourceValues(resourceValues)
    }
}
