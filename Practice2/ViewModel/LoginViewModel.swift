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
        emailValid.accept(email.isValidEmail())
    }
}

