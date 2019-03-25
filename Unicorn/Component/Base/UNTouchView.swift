//
//  UNTouchView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNTouchView: UIView {

    var isSelected: Bool = true
    var viewDelegate: UNTouchViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        isUserInteractionEnabled = true
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        closeButton.center = CGPoint(x: -12, y: -12)
        closeButton.setImage(UIImage(named: "story_maker_close"), for: .normal)
        closeButton.backgroundColor = .black
        closeButton.layer.cornerRadius = 12
        closeButton.layer.masksToBounds = true
        addSubview(closeButton)
    }
    
    @objc
    fileprivate func closeButtonClick() {
        if viewDelegate != nil {
            viewDelegate!.UNTouchViewCloseButtonClick()
        } else {
            removeFromSuperview()
        }
    }
}

private extension Selector {
    static let close = #selector(UNTouchView.closeButtonClick)
}


protocol UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick()
}

private extension UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick() {}
}
