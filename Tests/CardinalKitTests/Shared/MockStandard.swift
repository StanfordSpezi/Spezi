//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if DEBUG
import CardinalKit


public actor MockStandard: Standard {
    public init() {}
    
    
    func fulfill(expectation: XCTestExpectation) {
        expectation.fulfill()
    }
}
#endif
