//
//  LoginRootView.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import SwiftUI

struct LoginRootView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Log in to continue")
                    .font(.title2)
                    .foregroundColor(.black)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.5)),
                        alignment: .bottom
                    )
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black.opacity(0.5)),
                        alignment: .bottom
                    )
                
                if let message = viewModel.errorMessage {
                    Text(message)
                        .foregroundStyle(.red)
                }
                Spacer()
                signupButton
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accentColor(.black)
            .padding(.horizontal, 20)
        }
    }
    
    private var signupButton: some View {
        Button(action: viewModel.login) {
            HStack {
                Text("Login")
                Image(systemName: "arrow.right")
            }
        }
        .buttonStyle(PrimaryButtonStyle(textColor: .black, backgroundColor: viewModel.isLoginButtonEnabled ? .white : .gray.opacity(0.5)))
        .disabled(!viewModel.isLoginButtonEnabled)
    }
}

//MARK: Should use Mock Object instead
#Preview {
    LoginRootView(viewModel: .init(authService: AuthService()) { _ in })
}
