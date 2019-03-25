//
//  UNContentViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .gray
        
        let stickerWow = UNSticerView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(stickerWow)
        stickerWow.stickerImage = UIImage(named: "sticker_wow")
    }
}
