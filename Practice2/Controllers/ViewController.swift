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
    
    @IBOutlet private weak var emailTextField: AuthTextField!
    @IBOutlet private weak var passwordTextField: AuthTextField!
    @IBOutlet private weak var loginButton: UIButton!
    let loginVM: LoginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    let animationDuration: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupBindings() {
        emailTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(emailTextField.rx.text.orEmpty)
            .bind { text in
                self.loginVM.emailValid.accept(text.isValidEmail())
                if text.isEmpty {
                    self.emailTextField.borderColor = UIColor.systemRed
                }else {
                    self.emailTextField.borderColor = UIColor.systemGray
                }
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(passwordTextField.rx.text.orEmpty)
            .bind { text in
                self.loginVM.passwordValid.accept((text.count >= 6) ? true : false)
                if text.isEmpty {
                    self.passwordTextField.borderColor = UIColor.systemRed
                }else {
                    self.passwordTextField.borderColor = UIColor.systemGray
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
            self.loginButton.backgroundColor = status ? .systemBlue : .systemGray
        }
        .disposed(by: disposeBag)
        
    }
    
    private func configureUI() {
        self.loginButton.layer.cornerRadius = 8
        self.emailTextField.alpha = 0.0
        
        self.passwordTextField.alpha = 0.0
        self.loginButton.alpha = 0.0
        
        UIView.animate(withDuration: 1.0) {
            self.emailTextField.alpha = self.animationDuration
            self.passwordTextField.alpha = self.animationDuration
            self.loginButton.alpha = self.animationDuration
        }
    }
    
    @IBAction func login(_ sender: Any) {
        print("tapped")
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let signUpVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "SignUpVC") as? SignUpViewController else {
            return
        }
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}

