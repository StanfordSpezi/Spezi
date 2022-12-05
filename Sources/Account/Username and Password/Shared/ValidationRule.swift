//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


struct ValidationRule: Decodable {
    enum CodingKeys: String, CodingKey {
        case rule
        case message
    }
    
    
    private let rule: (String) -> Bool
    private let message: String
    
    
    init(rule: @escaping (String) -> Bool, message: String) {
        self.rule = rule
        self.message = message
    }
    
    init(regex: Regex<AnyRegexOutput>, message: String) {
        self.rule = { input in
            (try? regex.wholeMatch(in: input) != nil) ?? false
        }
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let regexString = try values.decode(String.self, forKey: .rule)
        let regex = try Regex<AnyRegexOutput>(regexString)
        
        let message = try values.decode(String.self, forKey: .message)
        
        self.init(regex: regex, message: message)
    }
    
    
    func validate(_ input: String) -> String? {
        guard !rule(input) else {
            return nil
        }
        
        return message
    }
}
