//
//  SwiftUIView.swift
//  
//
//  Created by Paul Shmiedmayer on 11/20/22.
//

import SwiftUI


struct UsernamePasswordSignUpView: View {
    enum Constants {
        static let formVerticalPadding: CGFloat = 8
    }
    
    
    let signUpOptions: SignUpOptions
    @State var username: String = ""
    
    
    var body: some View {
        Form {
            Section {
                Grid(alignment: .leading) {
                    GridRow {
                        Text("USERNAME", bundle: .module)
                            .fontWeight(.semibold)
                        TextField(String(localized: "USERNAME", bundle: .module), text: $username)
                    }
                        .padding(.top, -11 + Constants.formVerticalPadding)
                        .padding(.bottom, Constants.formVerticalPadding)
                    Divider()
                    GridRow {
                        Text("PASSWORD", bundle: .module)
                            .fontWeight(.semibold)
                        TextField(String(localized: "PASSWORD", bundle: .module), text: $username)
                    }
                        .padding(.vertical, Constants.formVerticalPadding)
                    Divider()
                    GridRow {
                        Text("CONFIRM_PASSWORD", bundle: .module)
                            .fontWeight(.semibold)
                        TextField(String(localized: "CONFIRM_PASSWORD", bundle: .module), text: $username)
                    }
                        .padding(.top, Constants.formVerticalPadding)
                        .padding(.bottom, -11 + Constants.formVerticalPadding)
                }
            } header: {
                Text("USERNAME_AND_PASSWORD_SECTION", bundle: .module)
            }
            Section {
                Text("")
            }
        }
    }
    
    
    init(signUpOptions: SignUpOptions = .default) {
        self.signUpOptions = signUpOptions
    }
}

struct UsernamePasswordSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        UsernamePasswordSignUpView()
    }
}
