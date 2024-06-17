//
//  LoginViewController.swift
//  RunTogether
//
//  Created by Jooeun Kim on 2024-06-17.
//

import UIKit
import RxRelay
import RxFlow

class LoginViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let  loginButton = UIButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    @objc func logIn() {
        steps.accept(LoginStep.loginIsComplete)
    }
}
