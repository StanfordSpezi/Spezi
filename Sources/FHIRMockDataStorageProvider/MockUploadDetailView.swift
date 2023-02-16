//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct MockUploadDetailView: View {
    let mockUpload: MockUpload
    
    
    var body: some View {
        List {
            Section(String(localized: "MOCK_UPLOAD_DETAIL_HEADER", bundle: .module)) {
                MockUploadHeader(mockUpload: mockUpload)
            }
            Section(String(localized: "MOCK_UPLOAD_DETAIL_BODY", bundle: .module)) {
                LazyText(text: mockUpload.body ?? "")
            }
        }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
    }
}


#if DEBUG
struct MockUploadDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MockUploadDetailView(
            mockUpload: MockUpload(
                id: UUID().uuidString,
                type: .add,
                path: "A Path",
                body: "A Body ..."
            )
        )
    }
}
#endif
