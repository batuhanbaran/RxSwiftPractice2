//
//  SignUpViewModel.swift
//  Practice2
//
//  Created by Batuhan BARAN on 11.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    let nameValid = BehaviorRelay<Bool>(value: false)
    let emailValid = BehaviorRelay<Bool>(value: false)
    let passwordValid = BehaviorRelay<Bool>(value: false)
    let incAtLeastNumbericVal = BehaviorRelay<Bool>(value: false)
    let incAtLeastSpecialChar = BehaviorRelay<Bool>(value: false)
    let incAtLeastCapitalLetter = BehaviorRelay<Bool>(value: false)
    
    func includeSpecialChar(_ password: String) -> Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: password)
    }
    
    func includeCapitalLetter(_ password: String) -> Bool {
        let upperCaseRegex = "(?s)[^A-Z]*[A-Z].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", upperCaseRegex)
        return testString.evaluate(with: password)
    }
}
