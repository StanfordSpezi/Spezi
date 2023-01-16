//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


/// <#Description#>
public enum Localization {
    /// <#Description#>
    public struct Passcode {
        /// <#Description#>
        public static let `default` = Passcode(
            passwordPrompt: String(moduleLocalized: "ACCESS_CODE_PASSCODE_PROMPT")
        )
        
        
        /// <#Description#>
        public let passwordPrompt: String
        
        
        /// <#Description#>
        /// - Parameter passwordPrompt: <#passwordPrompt description#>
        init(
            passwordPrompt: String = Self.default.passwordPrompt
        ) {
            self.passwordPrompt = passwordPrompt.localized
        }
    }
    
    /// <#Description#>
    public struct Biometrics {
        /// <#Description#>
        public static let `default` = Biometrics(
            biometricsPrompt: String(moduleLocalized: "ACCESS_CODE_BIOMETRICS_PROMPT")
        )
        
        
        /// <#Description#>
        public let biometricsPrompt: String
        
        
        /// <#Description#>
        /// - Parameter biometricsPrompt: <#biometricsPrompt description#>
        init(
            biometricsPrompt: String = Self.default.biometricsPrompt
        ) {
            self.biometricsPrompt = biometricsPrompt.localized
        }
    }
}
