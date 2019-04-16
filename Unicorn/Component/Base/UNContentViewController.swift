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
        stickerWow.imgViewModel = UNSticerView.ImageStickerViewModel(image: UIImage(named: "sticker_wow")!)
        
        let pan = UITapGestureRecognizer(target: self, action: #selector(panp))
        stickerWow.addGestureRecognizer(pan)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let vc = UNAlbumViewController()
            self.present(vc, animated: true, completion: nil)
            
            vc.imageSelected = {
                let width = CGFloat(100)
                let stickerWow = UNSticerView(frame: CGRect(x: 100, y: 100, width: width, height: width / $0))
                self.view.addSubview(stickerWow)
                self.stickerViews.append(stickerWow)
                stickerWow.imgViewModel = UNSticerView.ImageStickerViewModel(image: $1)
            }
        }
    }
    
    @objc func panp() {
        let tvc = UNTextViewController()
        present(tvc, animated: true, completion: nil)
        tvc.complateHandler = { viewModel in
            let textStickerView = UNSticerView(frame: CGRect(x: 20, y: 20, width: self.view.width - 30, height: tvc.textViewHeight!))
            self.view.addSubview(textStickerView)
            self.stickerViews.append(textStickerView)
            textStickerView.textViewModel = viewModel
        }
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
