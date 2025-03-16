//
//  MedBookLandingRootView.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import SwiftUI

struct MedBookLandingRootView: View {
    
    //MARK: Dependency
    let viewModel: MedBookLandingViewModel
    
    init(viewModel: MedBookLandingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.primaryBackground)
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 80)
                VStack {
                    logo
                    Spacer()
                    footer
                        .padding(.bottom, 50)
                }
            }
            .padding(16)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var logo: some View {
        Image(viewModel.logo)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    private var footer: some View {
        HStack {
            Button(viewModel.signupText) {
                viewModel.navigateTo(.signUp)
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .white))
            Button(viewModel.loginText) {
                viewModel.navigateTo(.signIn)
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .white))
        }
    }
}

#Preview {
    MedBookLandingRootView(viewModel: .init { _ in })
}
