//
//  UNTextViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNTextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        let backButton = UIButton(frame: CGRect(x: 15, y: topSafeAreaHeight + 10, width: 30, height: 30))
        view.addSubview(backButton)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        backButton.setTitle("←", for: .normal)
        
        let doneButton = UIButton(frame: CGRect(x: screenWidth - 30 - 15, y: backButton.top, width: backButton.width, height: backButton.height))
        view.addSubview(doneButton)
        doneButton.titleLabel?.font = backButton.titleLabel?.font
        doneButton.setTitle("✓", for: .normal)
    }
}
