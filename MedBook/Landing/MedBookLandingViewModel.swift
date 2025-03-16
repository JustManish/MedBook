//
//  MedBookLandingViewModel.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import DeveloperToolsSupport

enum LandingRoute {
    case signIn
    case signUp
}

struct MedBookLandingViewModel {
    
    let title: String = "MedBook"
    let logo: ImageResource = .logo
    let signupText = "Signup"
    let loginText = "Login"
    
    let navigateTo: (LandingRoute) -> ()
}
