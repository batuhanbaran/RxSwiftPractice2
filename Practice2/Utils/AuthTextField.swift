//
//  AuthTextField.swift
//  Practice2
//
//  Created by Batuhan BARAN on 11.09.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AuthTextField: UITextField {
    
    @IBInspectable
    var leftPadding: Int {
        get {
            return Int(leftView?.frame.height ?? 0)
        }
        set {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: Int(self.frame.height)))
            self.leftViewMode = .always
            self.leftView = view
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            let cgColor = UIColor.init(cgColor: layer.borderColor!)
            return cgColor
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
}

extension AuthTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(self.text ?? "")
    }
}
