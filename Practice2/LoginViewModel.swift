//
//  LoginViewModel.swift
//  Practice2
//
//  Created by Batuhan BARAN on 10.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
        
    let emailValid = BehaviorRelay<Bool>(value: false)
    let passwordValid = BehaviorRelay<Bool>(value: false)
    
    func validateAuth(_ email: String, _ password: String) {
        emailValid.accept(isValidEmail(email))
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

