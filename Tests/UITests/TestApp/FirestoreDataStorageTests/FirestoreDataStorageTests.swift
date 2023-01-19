//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@testable import FirestoreDataStorage
import SwiftUI


/// The Firestore tests require the Firebase Firestore Emulator to run at port 8080.
///
/// Refer to https://firebase.google.com/docs/emulator-suite/connect_firestore about more information about the
/// Firebase Local Emulator Suite.
struct FirestoreDataStorageTestsView: View {
    @EnvironmentObject var firebaseModule: Firestore<TestAppStandard>
    @State var error: Error?
    @State var element = TestAppStandard.BaseType(id: "TestElement")
    @State var runningTest = false
    @State var displayAlert = false
    
    
    var body: some View {
        Form {
            Text("The Firestore tests require the Firebase Firestore Emulator to run at port 8080.")
            Section("Element Information") {
                TextField(
                    "Id",
                    text: $element.id,
                    prompt: Text("Enter the element's identifier.")
                )
                TextField(
                    "CollectionPath",
                    text: $element.collectionPath,
                    prompt: Text("Enter the element's collection path.")
                )
                TextField(
                    "Context",
                    value: $element.content,
                    formatter: NumberFormatter(),
                    prompt: Text("Enter the element's optional context.")
                )
            }
            Section("Actions") {
                Button("Upload Element") {
                    uploadElement()
                }
                Button(
                    role: .destructive,
                    action: {
                        deleteElement()
                    },
                    label: {
                        Text("Delete Element")
                    }
                )
            }
                .disabled(runningTest)
        }
            .alert(isPresented: $displayAlert) {
                Alert(title: Text(error?.localizedDescription ?? "Unspecified Error"))
            }
            .navigationTitle("FirestoreDataStorage")
    }
    
    
    private func uploadElement() {
        Task {
            do {
                try await firebaseModule.process(.addition(element))
            } catch {
                self.error = error
                self.displayAlert = true
            }
        }
    }
    
    private func deleteElement() {
        Task {
            do {
                try await firebaseModule.process(.removal(element.removalContext))
            } catch {
                self.error = error
                self.displayAlert = true
            }
        }
    }
}


struct FirebaseDataStorageTestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FirestoreDataStorageTestsView()
        }
    }
}
