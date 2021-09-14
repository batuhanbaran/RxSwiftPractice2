//
//  SignUpViewController.swift
//  Practice2
//
//  Created by Batuhan BARAN on 11.09.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var fullNameTextField: AuthTextField!
    @IBOutlet private weak var emailTextField: AuthTextField!
    @IBOutlet private weak var passwordTextField: AuthTextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    let signUpVM = SignUpViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupBindings() {
        fullNameTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(fullNameTextField.rx.text.orEmpty)
            .bind { text in
                if text.isEmpty {
                    self.fullNameTextField.borderColor = UIColor.systemRed
                }else {
                    self.signUpVM.nameValid.accept(true)
                    self.fullNameTextField.borderColor = UIColor.systemGray
                }
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(emailTextField.rx.text.orEmpty)
            .bind { text in
                self.signUpVM.emailValid.accept(text.isValidEmail())
                if text.isEmpty {
                    self.emailTextField.borderColor = UIColor.systemRed
                }else {
                    self.emailTextField.borderColor = UIColor.systemGray
                }
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx
            .controlEvent(.allEditingEvents)
            .withLatestFrom(passwordTextField.rx.text.orEmpty)
            .bind { text in
                self.signUpVM.incAtLeastNumbericVal.accept((text.rangeOfCharacter(from: .decimalDigits) != nil))
                self.signUpVM.incAtLeastSpecialChar.accept(self.signUpVM.includeSpecialChar(text))
                self.signUpVM.incAtLeastCapitalLetter.accept(self.signUpVM.includeCapitalLetter(text))
                self.signUpVM.passwordValid.accept((text.count >= 6) ? true : false)
                if text.isEmpty {
                    self.passwordTextField.borderColor = UIColor.systemRed
                }else {
                    self.passwordTextField.borderColor = UIColor.systemGray
                }
                UIView.animate(
                    withDuration: 0.7,
                    delay: 0,
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 1,
                    options: [],
                    animations: {
                        for view in self.stackView.arrangedSubviews {
                            view.isHidden = false
                            view.alpha = 1.0
                            view.layoutIfNeeded()
                        }
                    },
                    completion: nil
                )
            }
            .disposed(by: disposeBag)
    
        passwordTextField.rx
            .controlEvent(.editingDidEnd)
            .withLatestFrom(passwordTextField.rx.text.orEmpty)
            .bind { text in
                UIView.animate(
                    withDuration: 0.7,
                    delay: 0,
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 1,
                    options: [],
                    animations: {
                        for view in self.stackView.arrangedSubviews {
                            view.isHidden = true
                            view.alpha = 0.0
                            view.layoutIfNeeded()
                        }
                    },
                    completion: nil
                )
            }
            .disposed(by: disposeBag)
        
        if let firstStackView = self.stackView.arrangedSubviews[0] as? UIStackView,
           let secondStackView = self.stackView.arrangedSubviews[1] as? UIStackView,
           let thirdStackView = self.stackView.arrangedSubviews[2] as? UIStackView {
            if let icon = firstStackView.arrangedSubviews[0] as? UIImageView,
               let label = firstStackView.arrangedSubviews[1] as? UILabel  {
                self.signUpVM.incAtLeastNumbericVal.bind { status in
                    if status {
                        icon.image = UIImage(systemName: "checkmark.circle")
                        icon.tintColor = .systemGreen
                        label.textColor = .systemGreen
                    }else {
                        icon.image = UIImage(systemName: "xmark.circle")
                        icon.tintColor = .systemRed
                        label.textColor = .systemRed
                    }
                }
                .disposed(by: disposeBag)
            }
            
            if let icon = secondStackView.arrangedSubviews[0] as? UIImageView,
               let label = secondStackView.arrangedSubviews[1] as? UILabel  {
                self.signUpVM.incAtLeastSpecialChar.bind { status in
                    if status {
                        icon.image = UIImage(systemName: "checkmark.circle")
                        icon.tintColor = .systemGreen
                        label.textColor = .systemGreen
                    }else {
                        icon.image = UIImage(systemName: "xmark.circle")
                        icon.tintColor = .systemRed
                        label.textColor = .systemRed
                    }
                }
                .disposed(by: disposeBag)
            }
            
            if let icon = thirdStackView.arrangedSubviews[0] as? UIImageView,
               let label = thirdStackView.arrangedSubviews[1] as? UILabel  {
                self.signUpVM.incAtLeastCapitalLetter.bind { status in
                    if status {
                        icon.image = UIImage(systemName: "checkmark.circle")
                        icon.tintColor = .systemGreen
                        label.textColor = .systemGreen
                    }else {
                        icon.image = UIImage(systemName: "xmark.circle")
                        icon.tintColor = .systemRed
                        label.textColor = .systemRed
                    }
                }
                .disposed(by: disposeBag)
            }
        }
        
        Observable.combineLatest(
            self.signUpVM.emailValid.asObservable(),
            self.signUpVM.passwordValid.asObservable(),
            self.signUpVM.nameValid.asObservable(),
            self.signUpVM.incAtLeastCapitalLetter.asObservable(),
            self.signUpVM.incAtLeastNumbericVal.asObservable(),
            self.signUpVM.incAtLeastSpecialChar.asObservable()) {(
            email,password,name, capital, numeric, special) -> Bool in
            if email && password && name && capital && numeric && special {
                return true
            }
            
            return Bool()
        }.bind { status in
            self.signUpButton.isEnabled = status
            self.signUpButton.backgroundColor = status ? .systemBlue : .systemGray
        }
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        for view in self.stackView.arrangedSubviews {
            view.isHidden = true
            view.alpha = 0.0
        }
        self.signUpButton.layer.cornerRadius = 8
        self.fullNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let name = self.fullNameTextField.text,
           let email = self.emailTextField.text,
           let password = self.passwordTextField.text {
            Api.shared.register(parameters: [
                "name": name,
                "email": email,
                "password": password
            ]) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.passwordTextField {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: stackView.frame.origin.y), animated: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.fullNameTextField:
            self.fullNameTextField.resignFirstResponder()
            self.emailTextField.becomeFirstResponder()
        case self.emailTextField:
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.view.endEditing(true)
        default:
            break
        }
        
        return Bool()
    }
}
