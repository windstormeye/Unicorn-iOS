//
//  UNUserLoginViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/7.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNUserLoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        
    }
    
    // 点击登录按钮
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard phoneNumberTextField.text != nil else { return }
        guard passwordTextField.text != nil else { return }

        guard phoneNumberTextField.text?.count == 11 else {
            self.tipsLabel.isHidden = false
            self.tipsLabel.text = "手机号错误"
            return
        }
        
        // 调用login方法。传信息给User。complateHandler完成后处理。
        User.shared.login(username: phoneNumberTextField.text!, password: passwordTextField.text!, complateHandler: { tipsString in
            // tipsString 用户不存在时返回报错信息
            if tipsString != nil {
                // 主线程更新 UI
                DispatchQueue.main.async {
                    // login方法中 可返回异常的原因
                    self.tipsLabel.isHidden = false
                    self.tipsLabel.text = tipsString
                }
            } else {
                // 如果用户存在，页面从上往下消失。
                self.dismiss(animated: true, completion: nil)
            }
        }) {
            print($0)
        }
    }
    
    // 点击注册按钮
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard phoneNumberTextField.text != nil else { return }
        guard passwordTextField.text != nil else { return }
        
        guard phoneNumberTextField.text?.count == 11 else {
            self.tipsLabel.isHidden = false
            self.tipsLabel.text = "手机号错误"
            return
        }
        
        // 调用register方法。传信息给User。complateHandler完成后处理。
        User.shared.register(username: phoneNumberTextField.text!, password: passwordTextField.text!, complateHandler: { tipsString in
            // tipsString 注册不成功时 返回报错信息
            if tipsString != nil {
                // 主线程更新 UI
                DispatchQueue.main.async {
                    // register方法中 可返回异常的原因
                    self.tipsLabel.isHidden = false
                    self.tipsLabel.text = tipsString
                }
            } else {
                // 注册成功 界面消失
                self.dismiss(animated: true, completion: nil)
            }
        }) {
            print($0)
        }
    }
    
}
