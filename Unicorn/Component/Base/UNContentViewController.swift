//
//  UNContentViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNContentViewController: UIViewController {

    private var stickerViews = [UNSticerView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .gray
        
        let stickerWow = UNSticerView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(stickerWow)
        stickerViews.append(stickerWow)
        stickerWow.stickerImage = UIImage(named: "sticker_wow")
    }
}

// MARK: Touch
extension UNContentViewController {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: view)
        var isSelected = false
        
        for stickerView in stickerViews {
            if stickerView.frame.contains(touchPoint!) && !isSelected {
                stickerView.isSelected = true
                isSelected = true
            } else {
                stickerView.isSelected = false
            }
        }
    }
}
