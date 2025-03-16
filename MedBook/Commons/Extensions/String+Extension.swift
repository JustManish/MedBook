//
//  String+Extension.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*)(?=.*[a-z])(?=.*[$@$!%*#?&])[A-Za-z0-9$@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
    
    func containsUppercase() -> Bool {
        return self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    func containsSpecialCharacter() -> Bool {
        let specialChars = CharacterSet(charactersIn: "!@#$%^&*()_+{}:;<>,.?/~\\-")
        return self.rangeOfCharacter(from: specialChars) != nil
    }
}
