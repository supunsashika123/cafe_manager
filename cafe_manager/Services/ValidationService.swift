//
//  ValidationService.swift
//  cafe_manager
//
//  Created by Supun Sashika on 2021-04-30.
//

import Foundation

struct ValidationService {
    func validateEmail(_ email:String?) throws -> String {
        guard let email = email else { throw ValidationError.invalidValue }
        guard isValidEmail(email) else { throw ValidationError.invalidEmailFormat }
        return email
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword(_ password:String?) throws -> String {
        guard let password = password else { throw ValidationError.invalidValue }
        return password
    }
}


enum ValidationError: LocalizedError {
    case invalidValue
    case invalidEmailFormat
    
    var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "Invalid value."
        case .invalidEmailFormat:
            return "Invalid email format."
        }
    }
}
