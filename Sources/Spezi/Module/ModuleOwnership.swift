//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Determine the ownership policy when loading a `Module`.
public enum ModuleOwnership {
    /// The Module is externally managed.
    ///
    /// Externally Modules are weakly referenced by Spezi and might deallocated at anytime.
    /// If they were not required by any other modules, the deallocation of an externally Module will automatically result in corresponding resources to be deallocated.
    ///
    /// - Important: Externally-managed Module **cannot** conform to the ``EnvironmentAccessible`` protocol.
    @_spi(APISupport)
    case external

    /// The module is managed and strongly referenced by Spezi.
    case spezi
}
