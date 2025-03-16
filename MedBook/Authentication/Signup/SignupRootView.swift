//
//  SignupRootView.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import SwiftUI

struct SignupRootView: View {
    
    @ObservedObject var viewModel: SignupViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sign up to continue")
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
                
                passwordValidations
                countryPicker
                    .frame(height: 140)
                Spacer()
                signupButton
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accentColor(.black)
            .padding(.horizontal, 20)
        }
        .task {
            await viewModel.loadCountries()
            await viewModel.loadCountry()
        }
    }
    
    private var passwordValidations: some View {
        VStack(alignment: .leading, spacing: 10) {
            PasswordValidationView(isValid: viewModel.password.count >= 8, text: "At least 8 characters")
            PasswordValidationView(isValid: viewModel.password.containsUppercase(), text: "Must contain an uppercase letter")
            PasswordValidationView(isValid: viewModel.password.containsSpecialCharacter(), text: "Contains a special character")
        }
    }
    
    private var countryPicker: some View {
        Picker("Select Country", selection: $viewModel.selectedCountry) {
            ForEach(viewModel.countries, id: \.self) { countryObject in
                Text(countryObject.country)
                    .tag(countryObject.country)
            }
        }
        .pickerStyle(.wheel)
        .padding()
    }
    
    private var signupButton: some View {
        Button(action: viewModel.register) {
            HStack {
                Text("Let's go")
                Image(systemName: "arrow.right")
            }
        }
        .buttonStyle(PrimaryButtonStyle(textColor: .black, backgroundColor: viewModel.isSignupButtonEnabled ? .white : .gray.opacity(0.5)))
        .disabled(!viewModel.isSignupButtonEnabled)
    }
}

struct PasswordValidationView: View {
    let isValid: Bool
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: isValid ? "checkmark.square" : "square")
                .foregroundColor(isValid ? .green : .primary)
            Text(text)
                .foregroundColor(isValid ? .green : .primary)
        }
    }
}

#Preview {
    SignupRootView(viewModel: .init(service: CountriesService(), authService: AuthService()) {_ in })
}
