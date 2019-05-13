//
//  UNUserLoginViewController.swift
//  Unicorn
//
//  Created by YiYi on 2019/5/7.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit

class UNUserLoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard phoneNumberTextField.text != nil else { return }
        guard passwordTextField.text != nil else { return }
        

        User.shared.login(username: phoneNumberTextField.text!, password: passwordTextField.text!, complateHandler: {
            self.dismiss(animated: true, completion: nil)
        }) {
            print($0)
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard phoneNumberTextField.text != nil else { return }
        guard passwordTextField.text != nil else { return }
        
        User.shared.register(username: phoneNumberTextField.text!, password: passwordTextField.text!, complateHandler: {
            self.dismiss(animated: true, completion: nil)
        }) {
            print($0)
        }
    }
    
}
