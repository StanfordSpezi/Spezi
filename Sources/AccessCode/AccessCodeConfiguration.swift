//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public enum AccessCodeConfiguration {
    /// <#Description#>
    /// - Parameters:
    ///   - codeOptions: <#Description#>
    ///   - passwordLocalization: <#Description#>
    case codeIfUnprotected(
        codeOptions: CodeOptions = .all,
        passwordLocalization: Localization.Passcode = .default
    )
    /// <#Description#>
    /// - Parameters:
    ///   - codeOptions: <#Description#>
    ///   - passwordLocalization: <#Description#>
    case code(
        codeOptions: CodeOptions = .all,
        passwordLocalization: Localization.Passcode = .default
    )
    /// <#Description#>
    /// - Parameters:
    ///   - codeOptions: <#Description#>
    ///   - passwordLocalization: <#Description#>
    ///   - biometricsLocalization: <#Description#>
    case biometrics(
        codeOptions: CodeOptions = .all,
        passwordLocalization: Localization.Passcode = .default,
        biometricsLocalization: Localization.Biometrics = .default
    )
    
    
    var codeOptions: CodeOptions {
        switch self {
        case let .codeIfUnprotected(codeOptions, _),
             let .code(codeOptions, _),
             let .biometrics(codeOptions, _, _):
            return codeOptions
        }
    }
    
    var passwordLocalization: Localization.Passcode {
        switch self {
        case let .codeIfUnprotected(_, passwordLocalization),
             let .code(_, passwordLocalization),
             let .biometrics(_, passwordLocalization, _):
            return passwordLocalization
        }
    }
    
    var biometricsLocalization: Localization.Biometrics {
        switch self {
        case .codeIfUnprotected, .code:
            return Localization.Biometrics.default
        case let .biometrics(_, _, biometricsLocalization):
            return biometricsLocalization
        }
    }
}
