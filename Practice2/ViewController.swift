//
//  ViewController.swift
//  Practice2
//
//  Created by Batuhan BARAN on 10.09.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    let loginVM: LoginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    let animationDuration: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupBindings()
    }
    
    private func setupBindings() {
        emailTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(emailTextField.rx.text.orEmpty)
            .bind { text in
                self.loginVM.emailValid.accept(self.loginVM.isValidEmail(text))
                if text.isEmpty {
                    self.emailTextField.layer.borderColor = UIColor.systemRed.cgColor
                }else {
                    self.emailTextField.layer.borderColor = UIColor.systemGray.cgColor
                }
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(passwordTextField.rx.text.orEmpty)
            .bind { text in
                self.loginVM.passwordValid.accept((text.count >= 6) ? true : false)
                if text.isEmpty {
                    self.passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
                }else {
                    self.passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
                }
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(self.loginVM.emailValid.asObservable(), self.loginVM.passwordValid.asObservable()) { (email, password) -> Bool in
            if email && password {
                return true
            }
            
            return Bool()
        }
        .bind { status in
            self.loginButton.isEnabled = status
            self.loginButton.backgroundColor = status ? .systemBlue : .gray
        }
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.emailTextField.alpha = 0.0
        self.passwordTextField.alpha = 0.0
        self.loginButton.alpha = 0.0
        UIView.animate(withDuration: 1.0) {
            self.emailTextField.alpha = self.animationDuration
            self.passwordTextField.alpha = self.animationDuration
            self.loginButton.alpha = self.animationDuration
        }
        
        self.emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        self.emailTextField.layer.cornerRadius = 8
        self.emailTextField.layer.borderWidth = 0.8
        self.emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.emailTextField.frame.height))
        self.emailTextField.leftViewMode = .always
        
        self.passwordTextField.layer.borderColor = UIColor.systemGray.cgColor
        self.passwordTextField.layer.cornerRadius = 8
        self.passwordTextField.layer.borderWidth = 0.8
        self.passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.passwordTextField.frame.height))
        self.passwordTextField.leftViewMode = .always
        self.passwordTextField.isSecureTextEntry = true
        
        self.loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func login(_ sender: Any) {
        print("tapped")
    }
}

